Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab0J0ITz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:19:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54261 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0J0ITt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:19:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I9LSY1kszcLmlImOChhRG4WGQ+qab29OXyCA+5PrTvdvXnirZ1qmt43h/bPmgf4s5O
         n8uKbWkTtzOGCIeW/6xLCmMZiMqXgZ+iwZtybrS2fRH4dQ8f25QazKLMzrAP4wZHXbhV
         PQHaLKInV98drvpx1q0LcFZL5OQc4TvPByHLY=
MIME-Version: 1.0
In-Reply-To: <496565EC904933469F292DDA3F1663E602F49E29F7@dlee06.ent.ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
	<1288054306-4361-2-git-send-email-x0095840@ti.com>
	<AANLkTimCDM_nruvh_gqxxy0CVnw2sH5UYNT9VgyeBfZN@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F49E280A@dlee06.ent.ti.com>
	<1288112616-notmuch-felipe.contreras@nokia.com>
	<496565EC904933469F292DDA3F1663E602F49E28BD@dlee06.ent.ti.com>
	<1288121251-notmuch-felipe.contreras@nokia.com>
	<496565EC904933469F292DDA3F1663E602F49E29F7@dlee06.ent.ti.com>
Date: Wed, 27 Oct 2010 11:19:47 +0300
Message-ID: <AANLkTimwbNV227yhPy-5E5rdAL2LciKeCSouWGW9H+WG@mail.gmail.com>
Subject: Re: [PATCH 1/8] staging: tidspbridge - remove req_addr from proc_map
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 11:39 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
>> fernando.lugo@ti.com wrote:
>> > > fernando.lugo@ti.com wrote:
>> > > > > On Tue, Oct 26, 2010 at 3:51 AM, Fernando Guzman Lugo
>> > > > > <x0095840@ti.com> wrote:
>> > > > > > The device address is assigned by tidspbridge no need for
>> > > > > that parameter anymore.
>> > > > > >
>> > > > > > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
>> > > > >
>> > > > > This would break the API with user-space, right?
>> > > >
>> > > > Yes, user-space needs to be changed accordingly.
>> > >
>> > > Wouldn't it make sense to avoid stuffing so many changes at once
>> > > including ABI breakage?
>> > >
>> > > Does user-space really _needs_ to be changed? Can't you
>> just ignore
>> > > that argument?
>> >
>> > Actually, I had a previous version of that patch where I
>> only Ignored
>> > that paramteter. But after thinking again and seeing How
>> the long time
>> > ago depreacted function are still there I Removed the parameter in
>> > order to force apps to make the change.
>>
>> Again, can we concentrate on first getting this thing to work?
>
> If to make it work for 37 the iommu migration patch will be revert
> These set of patches will have to wait until the patches are merged
> Again. So the dspbridge would be "fix" first a then the patches would
> Be merged.

I couldn't parse this correctly, but yes, I think.

>> We can think on breaking things again later.
>>
>> > You can ignore that argument at API level, so all users of
>> the API not
>> > need to have change (in that momment). That should be Only few line
>> > change.
>>
>> Yes, that's what I'm proposing.
>
> I meant userspace api or library level:
> Example:
>
> Dsp_proc_map(proc, mpu_addr, req_addr, *dsp_addr, attr) {
> ...
>        struct proc_map args = {
>                .map_addr = mpu_addr;
>                /* ignore req_addr */
>                .dsp_addr = dsp_addr;
>                .attr = attr;
>        }
>
>        ret = ioctl(handle, PROCMAP_CMD, args)
> ...
> }

Yes, but this has to be done on every library/app that is using the dsp.
It's much easier to do it on kernel side.

Besides, at least on gst-dsp we want it to work for _all_ bridge
versions, so it would be:

@@ -829,7 +829,9 @@ struct map_mem {
        void *proc_handle;
        void *mpu_addr;
        unsigned long size;
+#if DSP_API >= 3
        void *req_addr;
+#endif
        void **ret_map_addr;
        unsigned long attr;
 };
@@ -838,7 +840,9 @@ bool dsp_map(int handle,
                void *proc_handle,
                void *mpu_addr,
                unsigned long size,
                void *req_addr,
                void *ret_map_addr,
                unsigned long attr)
 {
@@ -846,7 +850,9 @@ bool dsp_map(int handle,
                .proc_handle = proc_handle,
                .mpu_addr = mpu_addr,
                .size = size,
+#if DSP_API >= 3
                .req_addr = req_addr,
+#endif
                .ret_map_addr = ret_map_addr,
                .attr = attr,
        };

But then if we are breaking the API already, wouldn't it make sense to
use the DMA direction too? (probably on the 'attr' field)

That's why it's a good idea to discuss API breakage, and not do it
willi-nillii. Otherwise we would have #if DSP_API >= 4, and so on.

But it's a bit pointless to be discussing about this at this point
while people are still struggling to get this working and don't know
which branch to use.

Look, you sent patches that broke the bridge (even after manually
applying all the dependency patches), since Omar wasn't there as
gatekeeper and Greg immediately merge them we now have a bridge that
is further broken. And now you want to break it even more arguing that
you want to force people to use the new API, but how do you expect
people to migrate to this new API if they can't even run this?

Besides, if you want to break API you should at least mention that
clearly in the patch.

>> > > > > I think this change should be delayed, preferably
>> after we have
>> > > > > a working tidspbridge.
>> > > >
>> > > > The issue you were seeing must be fixed with patch 2/8, and
>> > > Having all
>> > > > the dependencies tidspbridge has to be working Properly.
>> > >
>> > > Yes, which might not happen at .37. If we revert the
>> iommu stuff, we
>> > > might have a chance at having a working bridge on .37.
>> >
>> > But havi that merged in tidspbridge make more pressure to
>> merged The
>> > dependencies, if not maybe that wont have event for .38.
>>
>> Those patches have been there for a while and there's no sign
>> of when they'll be merged. Also, remember that the fact that
>> the patches have been sent doesn't guarantee they would be on
>> this, or even the next cycle.
>>
>> Besides, the rule followed here is: it's ready when it's
>> ready. In the meantime the driver should work, and we can do
>> that rather easily.
>
> I don't have much experience in this kind of situacion if it is
> believed it is the best solution then ok for me.
>
>> > But That is just my opinion if you all are agree revert is the best
>> > Option I am ok, but I looks like more work reverting and rebaseing
>> > specially because it is a big change.
>>
>> git makes this easy.
>
> Till we need to fix all the conflics, make sure everything work
> Properly and then send it again to review. That can take a while,
> But it seems someone else is agree to revert the changes, so maybe
> That is the best to do in this situation.

Reverting or not reverting is not the question here.

The question is how do we get it working for .37? Are you completely
certain that all the dependent patches will be merged? Has Hiroshi
said it would happen? Has the ARM people? Are you familiar with the
release process enough to say so? I'm not so familiar, but my feeling
is that it's already late, and even if we revert the iommu changes we
might not be able to get this working on .37 either.

Even if we leave iommu out of the picture, there's still the ioremap()
issue that will appear when linux-arm is pulled, and then we need to
deal with memblock changes, which is still not clear what will happen.
And then we need to fix the breakage in the compilation due to the
layer violation with "control.h". I think that already too much
uncertainty.

Cheers.

-- 
Felipe Contreras
