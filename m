Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0DTKfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 06:35:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47411 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab0DTKfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 06:35:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=QWBopHuvAZxfLMUlgyGpL4/CVZ2s6Ai9hiA5oUBMzj5TvYvVFZi7VMsIyhHL98ZWE9
         Fc8lWL+rfQ3d0lAtm9rDVubqW6jUsOYW/qm8Zmpk8nS40x0/ZlhGsZE3DZnlcLrxfC/O
         VSNbtF0jpmKSQF7vMka/oTQA3q8tCOnE9B3EA=
MIME-Version: 1.0
Date: Tue, 20 Apr 2010 18:35:18 +0800
Message-ID: <i2x9b948ee41004200335vc229a59cvc0a08c35c949d7dd@mail.gmail.com>
Subject: A possible bug in reqsk_queue_hash_req()
From: Li Yu <raise.sail@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

     I found out a possible bug in reqsk_queue_hash_req(), it seem
that we should move "req->dl_next = lopt->syn_table[hash];" statement
into follow write lock protected scope.

     As I browsed source code, this function only can be call at rx
code path which is protected a spin lock over struct sock , but its
caller (  inet_csk_reqsk_queue_hash_add() ) is a GPL exported symbol,
so I think that we'd best move this statement into below write lock
protected scope.

     Below is the patch to play this change, please do not apply it on
source code, it's just for show.

    Thanks.

Yu

--- include/net/request_sock.h  2010-04-09 15:27:14.000000000 +0800
+++ include/net/request_sock.h        2010-04-20 18:11:32.000000000 +0800
@@ -247,9 +247,9 @@ static inline void reqsk_queue_hash_req(
        req->expires = jiffies + timeout;
        req->retrans = 0;
        req->sk = NULL;
-       req->dl_next = lopt->syn_table[hash];

        write_lock(&queue->syn_wait_lock);
+       req->dl_next = lopt->syn_table[hash];
        lopt->syn_table[hash] = req;
        write_unlock(&queue->syn_wait_lock);
 }
