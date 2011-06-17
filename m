Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab1FQNgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:36:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57841 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1FQNge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:36:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: f6bvp <f6bvp@free.fr>
Subject: Re: [AX25] inconsistent lock state
Date: Fri, 17 Jun 2011 15:36:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Jarek Poplawski <jarkao2@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org
References: <4B2CD772.1030106@upmc.fr> <20100115203654.GA3084@del.dom.local> <4DFA662D.5030302@free.fr>
In-Reply-To: <4DFA662D.5030302@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171536.15660.arnd@arndb.de>
X-Provags-ID: V02:K0:cxX3c2Dw/8YK8w1//M+0F83wjYUkWZf1AUvg/lPS4rp
 MYNFJWKAsltnCFHGGYl1weWQVuBuk5ujxCjBgU7qsHPF9Kj47Q
 zVfDnv4+gBuKk6I9Rvn7bdhQjkLVsokUfm3Davf/QYglazQXfP
 L3n4FRYibzKOFwKpYC/rdmJGvI6cjIBZ+6m+uJsWHgO9IEM/Hs
 dUgbsz+6OMiWq/iupOk6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011 22:23:09 f6bvp wrote:

> Jun 16 12:03:34 f6bvp-9 kernel: =================================
> Jun 16 12:03:34 f6bvp-9 kernel: [ INFO: inconsistent lock state ]
> Jun 16 12:03:34 f6bvp-9 kernel: 2.6.39.1 #3
> Jun 16 12:03:34 f6bvp-9 kernel: ---------------------------------
> Jun 16 12:03:34 f6bvp-9 kernel: inconsistent {IN-SOFTIRQ-R} -> {SOFTIRQ-ON-W} usage.
> Jun 16 12:03:34 f6bvp-9 kernel: ax25ipd/2813 [HC0[0]:SC0[0]:HE1:SE1] takes:
> Jun 16 12:03:34 f6bvp-9 kernel: (disc_data_lock){+++?.-}, at: [<ffffffffa018552b>] mkiss_close+0x1b/0x90 [mkiss]
> Jun 16 12:03:34 f6bvp-9 kernel: {IN-SOFTIRQ-R} state was registered at:
> ...
> Is there something wrong in AX25 code or (more unlikely) is this 
> operation not permitted ?

The message hints that disc_data_lock is aquired with softirqs disabled,
but does not itself disable softirqs, which can in rare circumstances
lead to a deadlock.

Does this fix it?

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -708,11 +708,11 @@ static struct mkiss *mkiss_get(struct tty_struct *tty)
 {
 	struct mkiss *ax;
 
-	read_lock(&disc_data_lock);
+	read_lock_bh(&disc_data_lock);
 	ax = tty->disc_data;
 	if (ax)
 		atomic_inc(&ax->refcnt);
-	read_unlock(&disc_data_lock);
+	read_unlock_bh(&disc_data_lock);
 
 	return ax;
 }
@@ -813,10 +813,10 @@ static void mkiss_close(struct tty_struct *tty)
 {
 	struct mkiss *ax;
 
-	write_lock(&disc_data_lock);
+	write_lock_bh(&disc_data_lock);
 	ax = tty->disc_data;
 	tty->disc_data = NULL;
-	write_unlock(&disc_data_lock);
+	write_unlock_bh(&disc_data_lock);
 
 	if (!ax)
 		return;
