Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1J0BTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 21:19:53 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:36798 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab1J0BTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 21:19:52 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Jiri Kosina" <jkosina@suse.cz>
Subject: RE: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
 staging
Thread-Topic: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out
 of staging
Thread-Index: AQHMiv2KcmQwABJKa0ij2IuJiEaIS5WKCPWAgAARPKCABb6OgP//jc6g
Date: Thu, 27 Oct 2011 01:19:50 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA51BAB@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1318658907-16698-1-git-send-email-kys@microsoft.com>
 <20111023072427.GA13268@core.coreip.homeip.net>
 <6E21E5352C11B742B20C142EB499E0481AA3369B@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20111027000926.GB6804@core.coreip.homeip.net>
In-Reply-To: <20111027000926.GB6804@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Wednesday, October 26, 2011 8:09 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; linux-
> input@vger.kernel.org; Haiyang Zhang; Jiri Kosina
> Subject: Re: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
> staging
> 
> On Sun, Oct 23, 2011 at 03:45:14PM +0000, KY Srinivasan wrote:
> > > > +
> > > > +	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
> > > > +	if (t == 0) {
> > > > +		ret = -ETIMEDOUT;
> > > > +		goto cleanup;
> > > > +	}
> > > > +
> > > > +	response = &input_dev->protocol_resp;
> > > > +
> > > > +	if (!response->response.approved) {
> > > > +		pr_err("synthhid protocol request failed (version %d)",
> > > > +		       SYNTHHID_INPUT_VERSION);
> > > > +		ret = -ENODEV;
> > > > +		goto cleanup;
> > > > +	}
> > > > +
> > > > +	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
> > >
> > > We just completed the wait for this completion, why are we waiting on
> > > the same completion again?
> >
> > In response to our initial query, we expect the host to respond back with two
> > distinct pieces of information; we wait for both these responses.
> 
> I think you misunderstand how completion works in Linux. IIRC about
> Windows events they are different ;) You can not signal completion
> several times and then expect to wait corrsponding number of times. Once
> you signal completion is it, well, complete.

Looking at the code for complete(), it looks like the "done" state is incremented
each time complete() is invoked and  the  code for do_wait_for_common() decrements the 
done state each time it is invoked (if the completion is properly signaled and we are not dealing
with a timeout. So, what am I missing here.

> 
> >
> > >
> > > > +	if (t == 0) {
> > > > +		ret = -ETIMEDOUT;
> > > > +		goto cleanup;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * We should have gotten the device attr, hid desc and report
> > > > +	 * desc at this point
> > > > +	 */
> > > > +	if (input_dev->dev_info_status)
> > > > +		ret = -ENOMEM;
> > >
> > > -ENOMEM seems wrong.
> > >
> > There are many failures here and not being able to allocate memory is the
> > primary one; and so I chose to capture that.
> 
> Any chance that these failures have their own exit paths?

This is called from the probe functions and these errors are percolated up. On a different
note, I cleaned up this code based on the feedback I got from you. The patches have been 
sent out.

Regards,

K. Y

