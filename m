Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab2CDOsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 09:48:38 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37749 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab2CDOsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 09:48:37 -0500
Message-ID: <1330872513.2858.14.camel@dabdike.int.hansenpartnership.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Date: Sun, 04 Mar 2012 08:48:33 -0600
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B74886F@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
	 <20120304091225.GA27297@infradead.org>
	 <6E21E5352C11B742B20C142EB499E0481B74886F@TK5EX14MBXC126.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-03-04 at 14:23 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Sunday, March 04, 2012 4:12 AM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> > jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> > Haiyang Zhang
> > Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> > the host
> > 
> > On Fri, Mar 02, 2012 at 12:49:07PM -0800, K. Y. Srinivasan wrote:
> > > Windows hosts don't handle the ATA_16 command; don't pass it to the host.
> > 
> > Most devices don't handle it, and answer with and unsupported opcode
> > sense reason.  If hyperv iis buggy enough to crap out on it please add
> > a comment explaining that.
> 
> The host does not "crap out", it does return an error code but it is not "unsupported opcode".
> The sense reason that comes back is a generic error SRB_STATUS code. It is easier for me to filter the
> command on the outgoing side as opposed to dealing with a generic error code that is coming back from
> the host.

That's the wrong thing to do ... you need to unwrap the error code.
The reason being I presume it's not impossible for Windows to host a
device supporting ATA_16 and there are signs that this is going to be
necessary to prevent data corruption on some USB devices ... if you just
filter the command without checking if the host supports it, you're
going to end up perpetuating the corruption problem.

The general rule of thumb for avoiding this is to let the lower layers
handle as much as possible, and only begin behaviour alterations in the
upper layers if the lower layers have a provable and usually fatal
failure.

James


