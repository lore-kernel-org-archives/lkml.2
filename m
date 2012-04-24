Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab2DXEGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 00:06:07 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:49236 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab2DXEGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 00:06:05 -0400
Message-ID: <4F9626AA.7070900@msgid.tls.msk.ru>
Date: Tue, 24 Apr 2012 08:06:02 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: "stable@kernel.org" <stable@kernel.org>, autofs@vger.kernel.org,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Breaking userspace? Re: 3.0.24 broke aufofs on mixed 32/64bit
 environment
References: <4F94222C.6080608@msgid.tls.msk.ru>  <1335172741.2226.10.camel@perseus.themaw.net>  <4F958352.7050106@msgid.tls.msk.ru> <4F95897B.2040103@msgid.tls.msk.ru>  <4F959A5A.8070907@msgid.tls.msk.ru>  <1335230757.2260.15.camel@perseus.themaw.net> <1335238831.2260.17.camel@perseus.themaw.net>
In-Reply-To: <1335238831.2260.17.camel@perseus.themaw.net>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.04.2012 07:40, Ian Kent wrote:
> On Tue, 2012-04-24 at 09:25 +0800, Ian Kent wrote:
>> On Mon, 2012-04-23 at 22:07 +0400, Michael Tokarev wrote:
[]
>>>> So it looks like the kernel/user interface had an error,

for 6 years,

>>>> userspace adopted to the kernel by doing something, so
>>>> it started working.  And next kernel adopted to the un-
>>>> patched userspace, thus breaking patched userspace.

(The commit in question is 499f286dc02cde6b668e2d757dfe100cb0c43445
from Feb 2012, released in 3.3, original bug went into kernel in
2006, as 5c0a32fc2cd0).

>>>>
>>>> That's quite messy... :(  And I'm not sure what to do
>>>> about this, -- the only solution - in my opinion anyway -
>>>> is to revert this kernel patch and maybe switch to a
>>>> new protocol version.
>>>
>>> Okay, even if messy, there are quite easy pure userspace
>>> solutions to all this.
>>>
>>> But first of all, I want to question this change in the
>>> first place, hence CC'ing to LKML too.
>>
>> Back porting the 3.3 change to current stable kernels was not a good
>> idea IMO and I probably should have NAKed the one that I actually saw,
>> which was devoid of version btw.
>>
>> The change came about because there was a complaint about me not wanting
>> to fix this in the kernel, but wanting to continue using the user space
>> workaround. But it was insisted that it be fixed in the kernel, and so
>> it was done.

Who insisted on this?

Note my question is not about stable series anymore, it is about the
original "fix" which went into 3.3 kernel, which, having in mind that
interface has been this way for 6 years and userspace adopted, should
not have been there in the first place.

>> Consequently people will encounter this gotcha sooner or later and will
>> need to apply a patch to resolve it. The back port to stable kernels
>> just means it's sooner rather than later.
>>
>> I have already told you that I will need to provide a (updated, since
>> there is already a commit in git that covers 3.3) patch for autofs. I
>> haven't done that yet because I've been a little ill.
> 
> AFAICT this patch is what's needed.
> Can you check please.
> 
> autofs-5.0.4 - allow for kernel packet size change

Please stop creating even more mess.  Just revert this patch from
kernel -- from BOTH stable and current mainline series.  Right
NOW, as an urgent fix, before 3.4 will be released (Cc'ing Linus
for this).

[]
> @@ -599,6 +600,13 @@ static size_t get_kpkt_len(void)
>  {
>  	size_t pkt_len = sizeof(struct autofs_v5_packet);
>  	struct utsname un;
> +	int kern_vers;
> +
> +	kern_vers = linux_version_code();
> +	if (kern_vers > KERNEL_VERSION(3, 2, 9) ||
> +	   (kern_vers > KERNEL_VERSION(3, 0, 23) &&
> +            kern_vers < KERNEL_VERSION(3, 1, 0)))
> +		return pkt_len;

Yeah, mess like this is absolutely disgusting... :(

[]
 +static inline unsigned int linux_version_code(void)
> +{
> +        struct utsname my_utsname;
> +        unsigned int p, q, r;
> +
> +        if (uname(&my_utsname))
> +                return 0;
> +
> +        p = (unsigned int)atoi(strtok(my_utsname.release, "."));
> +        q = (unsigned int)atoi(strtok(NULL, "."));
> +        r = (unsigned int)atoi(strtok(NULL, "."));
> +        return KERNEL_VERSION(p, q, r);

And here there's the same bug repeated again: there's no
guarantee that 3rd strtok() will return non-NULL.  But
this is irrelevant, just do not do that.  Pretty please,
it is not too late still.


Thank you!

/mjt
