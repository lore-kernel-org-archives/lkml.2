Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0E0NUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:20:03 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:47837 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab0E0NT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RiJv73M98wdo1koASTAbxqrK9zIswtvHu2lGonwyEUrbsC1zyzSreqGsaSN30OZ7UW
         Y/ijT93d/oexXpW6pwlMbo9YQlMLMpkJe/ILKRQ067X6lVSPq9xbP46u4+KgFEhUTYyi
         8c1qtAA5yv3GGIokOUW5FBAu7EOJ4glFQpd24=
MIME-Version: 1.0
In-Reply-To: <E1OHcV6-0000oz-C5@pomaz-ex.szeredi.hu>
References: <E1OHaLJ-0008VD-VJ@pomaz-ex.szeredi.hu>
	<AANLkTilGlR297cl9yHF5n6e4eU7JflJwrpm3TrIe-rlo@mail.gmail.com>
	<E1OHcV6-0000oz-C5@pomaz-ex.szeredi.hu>
Date: Thu, 27 May 2010 16:19:57 +0300
Message-ID: <AANLkTikrejgaNreRt2krs_djeFN-pmrEU5G-v08llao6@mail.gmail.com>
Subject: Re: [PATCH 1/2] vfs: sanitize __d_path()
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, john.johansen@canonical.com,
       penguin-kernel@i-love.sakura.ne.jp, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 3:47 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, 27 May 2010, Alexey Dobriyan wrote:
>> On Thu, May 27, 2010 at 1:29 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > From: Miklos Szeredi <mszeredi@suse.cz>
>> >
>> > __d_path() no longer appends " (deleted)" to unlinked paths.  This is
>> > moved into d_path() which is the only caller that cares.
>>
>> d_path() or equivalent should get "int *deleted" argument to distinguish
>> really deleted files. Then users can decide if they care or not.
>
> Why can't they distinguish deleted files by just calling d_unlinked()?

Why would they want to do it (which means taking locks again and
potential incoherence)?
The information is right there, ship it upwards:

+       if (deleted)
+               *deleted = 0;
        spin_lock(&vfsmount_lock);
        prepend(&end, &buflen, "\0", 1);
-       if (d_unlinked(dentry) &&
-               (prepend(&end, &buflen, " (deleted)", 10) != 0))
-                       goto Elong;
+       if (d_unlinked(dentry) && deleted)
+               *deleted = 1;

"(deleted)" as interface sucks, we can't change it,
at least, let's make in-kernel interface correct.
