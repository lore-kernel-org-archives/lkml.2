Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733Ab2BOJkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:40:20 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64594 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2BOJkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:40:17 -0500
Message-ID: <1329298813.2437.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] IPC: message queue stealing feature introduced
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, criu@openvz.org, lucas.demarchi@profusion.mobi,
        dhowells@redhat.com, linux-kernel@vger.kernel.org,
        serge.hallyn@canonical.com
Date: Wed, 15 Feb 2012 10:40:13 +0100
In-Reply-To: <20120215090711.11586.5396.stgit@localhost6.localdomain6>
References: <20120215090711.11586.5396.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 février 2012 à 13:08 +0400, Stanislav Kinsbursky a
écrit :
> This patch is required for checkpoint/restore in userspace project.
> C/r requires some way to get all pending IPC messages without deleting them for
> the queue (checkpoint can fail and in this case tasks will be resumed, so queue
> have to be valid).
> To achive this, new operation flag MSG_STEAL for sys_msgrcv() system call
> introduced.
> If this flag is set, then passed struct msgbuf pointer will be used for storing
> array of structures:
> 
> struct msgbuf_a {
> 	long mtype;         /* type of message */
> 	size_t msize;       /* size of message */
> 	char mtext[0];      /* message text */
> };
> 

This structure is not 32/64 bit safe and will need compat tricks.

+                       ret = do_steal_msg(mtext, arrsz, msg);
+                       if (ret < 0) {
+                               msg = ERR_PTR(ret);
+                               goto out_unlock;
+                       }
+                       mtext += ret + sizeof(struct msgbuf_a);
+                       arrsz -= ret + sizeof(struct msgbuf_a);

I cant see where alignement requirements are met.

(ret should be rounded up to a multiple of alignof(struct msgbuf_a)



