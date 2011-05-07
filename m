Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1EGGGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:06:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50797 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab1EGGGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:06:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LWx+U/4JkBs2mBtUBrkVbAfna2iNcCFgsUJC7kZJDfr6n+gsWivS4itMc3LWg8I1Pt
         K6qfuHT/ZjvsbT1Bg6vWQO9tglpUe8ix1TxvySe6KRwBjULWjTZo5QJFZF0zowiPfQVk
         RkNceBFbQWn+gf34yGyaWGUp3SZsEg0/1255g=
Subject: Re: [PATCH] fs: add FD_CLOFORK and O_CLOFORK
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1304743740-3405-1-git-send-email-xiaosuo@gmail.com>
References: <1304743740-3405-1-git-send-email-xiaosuo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 08:06:34 +0200
Message-ID: <1304748394.2821.654.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 07 mai 2011 à 12:49 +0800, Changli Gao a écrit :

>  
>  	for (i = open_files; i != 0; i--) {
>  		struct file *f = *old_fds++;
>  		if (f) {
> -			get_file(f);
> +			if (FD_ISSET(open_files - i, new_fdt->close_on_fork)) {
> +				FD_CLR(open_files - i, new_fdt->open_fds);
> +				f = NULL;
> +			} else {
> +				get_file(f);
> +			}
>  		} else {
>  			/*

You should change the main loop to

for (i = 0; i < open_files; i++) {
	struct file *f = *old_fds++;

	if (f && FD_ISSET(i, new_fdt->close_on_fork))
		f = NULL;
	if (f)
		get_file(f);
	else
		FD_CLR(i, new_fdt->open_fds)
	rcu_assign_pointer(*new_fds++, f);
}

BTW the rcu_assign_pointer() is not necessary here, since we are the
only thread populating new_fds at this point.

spin_unlock(&oldf->file_lock); and 
rcu_assign_pointer(newf->fdt, new_fdt);
make sure once new_fds is visible to other threads, all our memory
writes are committed.

sparse even warns us ;)

fs/file.c:371:3: warning: incorrect type in assignment (different address spaces)
fs/file.c:371:3:    expected struct file *<noident>
fs/file.c:371:3:    got struct file [noderef] <asn:4>*<noident>


I'll submit a patch in a separate thread


