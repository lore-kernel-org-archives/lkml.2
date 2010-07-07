Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0GGMxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:53:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48069 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab0GGMxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=U1X08JdnAk24fH+ImIAA/liFuWT0nDPWIolua9fQOvTL7E/ZDo1nkFlefvKUwGH6x4
         ON3zfdENEzX58dwpnQZ4IyQUY7U3CMPGoUAhjzceQO+gUw+66OOX37VsnshH2Hxr/EJC
         rp3BmsOZv6QYUXF+BYDs+Nnydxdt7pQpebHlM=
Message-ID: <4C3478AA.7070805@gmail.com>
Date: Wed, 07 Jul 2010 14:52:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: MEDIA: lirc, improper locking
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

stanse found a locking error in lirc_dev_fop_read:
if (mutex_lock_interruptible(&ir->irctl_lock))
  return -ERESTARTSYS;
...
while (written < length && ret == 0) {
  if (mutex_lock_interruptible(&ir->irctl_lock)) {    #1
    ret = -ERESTARTSYS;
    break;
  }
  ...
}

remove_wait_queue(&ir->buf->wait_poll, &wait);
set_current_state(TASK_RUNNING);
mutex_unlock(&ir->irctl_lock);                        #2

If lock at #1 fails, it beaks out of the loop, with the lock unlocked,
but there is another "unlock" at #2.

regards,
-- 
js
