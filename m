Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab1CXITq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:19:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36124 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab1CXITo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=StitXxproisMMyaYlBNpLAc3rPbhbgPRhuw74u+cZ5YCLFrFHrG8qww3OKv0t1ElpR
         wLkXP1HtrgYhzHw3DRpRxFnClyBd5XV/oL5KjgVc0xQIU5aFAttlQXO6rpFyA+13MJmE
         3kFDsb6z/IqH+rTgC5PfRAvpH3pQOdw/SdkYo=
MIME-Version: 1.0
In-Reply-To: <s5hzkoluifr.wl%tiwai@suse.de>
References: <AANLkTin1kqjSgh8R5zzt_tkJAsTV_LxDjpPf5ngUHEr1@mail.gmail.com>
	<s5hzkoluifr.wl%tiwai@suse.de>
Date: Thu, 24 Mar 2011 01:19:43 -0700
Message-ID: <AANLkTi=RtEZyiry1FWiaT5LQbm3r-_9X_f2jPOQ6YCex@mail.gmail.com>
Subject: Re: snd_card_disconnect race (sound/core/init.c)
From: Russ Dill <russ.dill@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:43 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 23 Mar 2011 18:40:58 -0700,
> Russ Dill wrote:
>>
>> With slub poisoning on, I'm seeing an oops in snd_disconnect_release
>> with slub poison (6b6b6b6b). Investigating, snd_card_disconnect looks
>> to be the possible culprit:
>>
>> 333         spin_lock(&card->files_lock);
>> 334         mfile = card->files;
>> 335         while (mfile) {
>> 336                 file = mfile->file;
>> 337
>> 338                 /* it's critical part, use endless loop */
>> 339                 /* we have no room to fail */
>> 340                 mfile->disconnected_f_op = mfile->file->f_op;
>> 341
>> 342                 spin_lock(&shutdown_lock);
>> 343                 list_add(&mfile->shutdown_list, &shutdown_files);
>> 344                 spin_unlock(&shutdown_lock);
>> 345
>> 346                 mfile->file->f_op = &snd_shutdown_f_ops;
>> 347                 fops_get(mfile->file->f_op);
>> 348
>> 349                 mfile = mfile->next;
>> 350         }
>> 351         spin_unlock(&card->files_lock);
>>
>> I'm not aware of any locking that would prevent the original release
>> function running concurrently if it were started before line 346 was
>> executed. The original release functions (such as snd_hwdep_release)
>> call snd_card_remove_file which frees the mfile object which would
>> have been just added to the shutdown_files list leading to a use of
>> freed (or in my case poisoned) memory later on down the line when the
>> shutdown_files gets walked again.
>>
>> It seems that 118dd6bf (ALSA: Clean up snd_monitor_file management,
>> v2.6.30) may have either introduced this problem or made it worse
>> since snd_card_file_remove previously removed items from the
>> shutdown_files list before freeing them.
>>
>> I'm currently experiencing these crashes on 2.6.32.26, but I can't
>> find any changes that would cause them not to occur on later kernel
>> versions.
>
> Which device are you using?  USB-audio had a known problem at
> disconnection, for example, and it was fixed recently.
>

I'm using USB-audio. I tried back-porting a couple of patches, to no avail:

ALSA: usb-audio: fix oops due to cleanup race when disconnecting
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=382225e6

ALSA: usb - Release capture substream URBs properly
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=76195fb0

Backing out 118dd6bf fixes the problem. The app that is running when
this crash occurs does full duplex streaming and segfaults while the
USB-audio device is going away. I'd have to check, but I think its
actually segfaulting it response to a disconnect of another piece of
the composite device the USB-audio device is part of, so the release
may actually be happening at the time the snd_card_disconnect is
occurring. I don't see any locking that would prevent bad things from
happening in this case, and the shutdown_files list is definitely
poisoned.
