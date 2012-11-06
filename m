Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2KFIEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:04:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42343 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab2KFIEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:04:51 -0500
MIME-Version: 1.0
In-Reply-To: <s5h4nl3i3u6.wl%tiwai@suse.de>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<s5hobjia6vj.wl%tiwai@suse.de>
	<20121031173728.GA18615@srcf.ucam.org>
	<s5h390utqv3.wl%tiwai@suse.de>
	<1351743715.21227.95.camel@linux-s257.site>
	<20121101131849.752df6fd@pyramind.ukuu.org.uk>
	<s5hip9k9dng.wl%tiwai@suse.de>
	<s5hhap49den.wl%tiwai@suse.de>
	<CACVXFVN8qPTgiYKXaeKFJXLXMjLE=+=8Vev2otD3v1VMk+Ez_w@mail.gmail.com>
	<s5h8vafi56z.wl%tiwai@suse.de>
	<CACVXFVPDZnXshvartbTt6gaGzcb+03sVq3Qm3apQQ8AVcQWerg@mail.gmail.com>
	<s5h4nl3i3u6.wl%tiwai@suse.de>
Date: Tue, 6 Nov 2012 16:04:50 +0800
Message-ID: <CACVXFVPJ0TWf=ffFhw+UGoGgsRnrD7o+Ws5rdDxS52jSf4SZ4A@mail.gmail.com>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
From: Ming Lei <tom.leiming@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 3:32 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 6 Nov 2012 15:16:43 +0800,
> Ming Lei wrote:
>>
>> On Tue, Nov 6, 2012 at 3:03 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> >
>> > Yeah, it's just uncovered in the patch.  As a easy solution, apply the
>> > patch like below to disallow the udev fw loading when signature check
>> > is enforced.
>> >
>> >
>> > thanks,
>> >
>> > Takashi
>> >
>> > ---
>> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>> > index 575bc4c..93121c3 100644
>> > --- a/drivers/base/firmware_class.c
>> > +++ b/drivers/base/firmware_class.c
>> > @@ -912,6 +912,13 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
>> >                 goto handle_fw;
>> >         }
>> >
>> > +       /* signature check isn't handled via udev fw loading */
>> > +       if (sig_enforce) {
>> > +               fw_load_abort(fw_priv);
>> > +               direct_load = 1;
>> > +               goto handle_fw;
>> > +       }
>> > +
>>
>> The above might be wrong if the firmware file doesn't exist in default
>> search paths.
>
> Heh, I didn't call it's a perfect patch.  It's just an easy solution,
> as mentioned.
>
>> You should skip loading from user space only if
>> verify_signature() returns false. And the udev loading should be
>> resorted to if there is no such firmware file in default search paths.
>
> ... and the kernel should ask udev again for the corresponding
> signature.

I mean you can't skip user space loading if there is no firmware file
in the default search path.  And you can do it if verify_signature()
returns false. So you needn't have to implement the signature for
user space loading.

> I'm too lazy to implement that just for unknown corner
> cases, so put the patch like above.

There might be some distributions in which the firmwares aren't stored
under the default search path, so your change may cause regression
on these distributions. And, it is a easy change in your patch to make
the situation working.

Also the default search path in firmware_class.c is from built-in path of
udev, and distributions may customize their firmware path by udev
configure option.

>
> Honestly speaking, I have a feeling that we should rather go for
> getting rid of udev fw loading.  The fw loader code is overly complex

Yes, I have the feeling too, but we need to make sure no regressions
introduced.

> just for udev handshaking.
>
> Do you know how many firmwares still rely on udev...?

Do you know how many distributions have switched to 3.7-rcX to
start using direct loading?

Thanks,
-- 
Ming Lei
