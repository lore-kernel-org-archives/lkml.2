Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1CXBlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 21:41:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50679 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1CXBk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 21:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ZXy1lhbn+44/f6RxVdcFdg2N5jKep/QK4Eu40Mnqc4zUMEtSkeap27frHERfRNUQDu
         zFGDX2bC5IGKA2OY8ZRV7TixiSm9h5MDGRYyGPNE7MSSKYpXqC9PWW8qpp6f6riOiTiA
         c3aOqhPk5WTyahcOAo/ZYjUfYIxJM5fkoZNDY=
MIME-Version: 1.0
Date: Wed, 23 Mar 2011 18:40:58 -0700
Message-ID: <AANLkTin1kqjSgh8R5zzt_tkJAsTV_LxDjpPf5ngUHEr1@mail.gmail.com>
Subject: snd_card_disconnect race (sound/core/init.c)
From: Russ Dill <russ.dill@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With slub poisoning on, I'm seeing an oops in snd_disconnect_release
with slub poison (6b6b6b6b). Investigating, snd_card_disconnect looks
to be the possible culprit:

333         spin_lock(&card->files_lock);
334         mfile = card->files;
335         while (mfile) {
336                 file = mfile->file;
337
338                 /* it's critical part, use endless loop */
339                 /* we have no room to fail */
340                 mfile->disconnected_f_op = mfile->file->f_op;
341
342                 spin_lock(&shutdown_lock);
343                 list_add(&mfile->shutdown_list, &shutdown_files);
344                 spin_unlock(&shutdown_lock);
345
346                 mfile->file->f_op = &snd_shutdown_f_ops;
347                 fops_get(mfile->file->f_op);
348
349                 mfile = mfile->next;
350         }
351         spin_unlock(&card->files_lock);

I'm not aware of any locking that would prevent the original release
function running concurrently if it were started before line 346 was
executed. The original release functions (such as snd_hwdep_release)
call snd_card_remove_file which frees the mfile object which would
have been just added to the shutdown_files list leading to a use of
freed (or in my case poisoned) memory later on down the line when the
shutdown_files gets walked again.

It seems that 118dd6bf (ALSA: Clean up snd_monitor_file management,
v2.6.30) may have either introduced this problem or made it worse
since snd_card_file_remove previously removed items from the
shutdown_files list before freeing them.

I'm currently experiencing these crashes on 2.6.32.26, but I can't
find any changes that would cause them not to occur on later kernel
versions.
