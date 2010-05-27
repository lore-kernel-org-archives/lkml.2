Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab0E0Nql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:46:41 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49488 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab0E0Nqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:46:39 -0400
To: adobriyan@gmail.com, miklos@szeredi.hu
Cc: viro@zeniv.linux.org.uk, john.johansen@canonical.com,
       penguin-kernel@i-love.sakura.ne.jp, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vfs: sanitize __d_path()
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
References: <E1OHaLJ-0008VD-VJ@pomaz-ex.szeredi.hu>
	<AANLkTilGlR297cl9yHF5n6e4eU7JflJwrpm3TrIe-rlo@mail.gmail.com>
	<E1OHcV6-0000oz-C5@pomaz-ex.szeredi.hu>
	<AANLkTikrejgaNreRt2krs_djeFN-pmrEU5G-v08llao6@mail.gmail.com>
In-Reply-To: <AANLkTikrejgaNreRt2krs_djeFN-pmrEU5G-v08llao6@mail.gmail.com>
Message-Id: <201005272246.AFJ57327.SMFOOOLQFHVFtJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 27 May 2010 22:46:35 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Why would they want to do it (which means taking locks again and
> potential incoherence)?
> The information is right there, ship it upwards:
> 
> +       if (deleted)
> +               *deleted = 0;
>         spin_lock(&vfsmount_lock);
>         prepend(&end, &buflen, "\0", 1);
> -       if (d_unlinked(dentry) &&
> -               (prepend(&end, &buflen, " (deleted)", 10) != 0))
> -                       goto Elong;
> +       if (d_unlinked(dentry) && deleted)
> +               *deleted = 1;
> 
> "(deleted)" as interface sucks, we can't change it,
> at least, let's make in-kernel interface correct.

We don't need vfsmount_lock for d_unlinked(), do we?
Then, I think we can do

+	if (deleted)
+		*deleted = d_unlinked(dentry);
 	spin_lock(&vfsmount_lock);
-	prepend(&end, &buflen, "\0", 1);
+	prepend(&end, &buflen, "", 1);
-	if (d_unlinked(dentry) &&
-	    (prepend(&end, &buflen, " (deleted)", 10) != 0))
-		goto Elong;
