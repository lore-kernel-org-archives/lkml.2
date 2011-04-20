Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab1DTR7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 13:59:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44855 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1DTR7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 13:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=g88Dlyyt89Yn8DxFd/JZ+uostMLZpn71bnvQ2gSfnlG+SyUeJQ0wm2BsGC90Pxi3Eh
         qTSfz5H8m/pPWR/gNGskLzVnTrHCvZtERCPrDv7EnsflCUd9ag/I/6wiO6gQJ4yVkKNw
         /kpAoH7v8jI981TpQ9QYrKDrllFYluA+tKvmg=
MIME-Version: 1.0
In-Reply-To: <20110420161513.GA25396@suse.de>
References: <BANLkTi=MjDqawZx=+fKjaAs5SPfGQDEgVQ@mail.gmail.com>
 <1302547378-14639-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110419235812.GA4619@kroah.com> <BANLkTi=q8jfEaLByZVZPHHYp_5PTK-36cw@mail.gmail.com>
 <20110420161513.GA25396@suse.de>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 20 Apr 2011 19:59:30 +0200
Message-ID: <BANLkTi=CTQ4mYE1QXZjxQ0RdkkoVV-jzQg@mail.gmail.com>
Subject: Re: [PATCH v2] driver core: let dev_set_drvdata return int instead of
 void as it can fail
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Viresh Kumar <viresh.kumar@st.com>,
        linux-arm-kernel@lists.infradead.org, shiraz.hashim@st.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/20 Greg KH <gregkh@suse.de>:
> On Wed, Apr 20, 2011 at 11:09:56AM +0200, Michał Mirosław wrote:
>> 2011/4/20 Greg KH <greg@kroah.com>:
>> > On Mon, Apr 11, 2011 at 08:42:58PM +0200, Uwe Kleine-König wrote:
>> >> Before commit
>> >>
>> >>       b402843 (Driver core: move dev_get/set_drvdata to drivers/base/dd.c)
>> >>
>> >> calling dev_set_drvdata with dev=NULL was an unchecked error. After some
>> >> discussion about what to return in this case removing the check (and so
>> >> producing a null pointer exception) seems fine.
>> > I'm confused by this thread, care to resend all of these in a series
>> > against the latest linux-next tree?
>>
>> I'd argue that dev_set_drvdata() should never fail. All current
>> drivers depend on this, and if dev_set_drvdata() fails, user will get
>> an OOPS a short while after the device finishes initializing (or maybe
>> even before that if callbacks are involved).
>> Allowing dev_set_drvdata() to fail will need putting a lot of
>> boilerplate code into drivers for no real gain.
>>
>> Please consider reverting commit
>> b4028437876866aba4747a655ede00f892089e14 instead of "fixing" issues it
>> generates.
>
> That patch was from 2009, surely if there were real issues with that
> change, it would have shown up in the past 2 years, right?
>
> And no, I don't want to revert that, we need that for future work in
> this area.
>
> I have no problem migrating the error code for that function on down,
> very few drivers call this function directly, it should be wrapped by
> bus-specific functions instead, right?  They can handle the error
> handling on their own and not force the individual drivers to handle it
> if needed.

> Have you ever seen this function fail?

When the allocation in device_private_init() fails, dev_set_drvdata()
leaves driver_data pointer not set.
But it looks like dev_set_drvdata() should not be called before
device_register(), so this check and allocation call there is
redundant.

So maybe the function should just look like this:

void dev_set_drvdata(struct device *dev, void *data)
{
  /* dev == NULL is a BUG; dev->p is allocated at device_register() time */
  BUG_ON(!dev->p);
  dev->p->driver_data = data;
}

Passing dev == NULL to dev_get_drvdata() is also a BUG, so:

void *dev_get_drvdata(const struct device *dev)
{
  return dev->p->driver_data;
}

Best Regards,
Michał Mirosław
