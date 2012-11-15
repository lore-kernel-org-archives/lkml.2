Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768017Ab2KOOKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:10:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:40159 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767800Ab2KOOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:10:19 -0500
Message-ID: <50A4F6F1.8080405@windriver.com>
Date: Thu, 15 Nov 2012 09:06:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.6-rt17
References: <alpine.LFD.2.02.1211122223300.10000@ionos> <50A3F75D.8090105@localhost>
In-Reply-To: <50A3F75D.8090105@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-11-14 02:56 PM, Fernando Lopez-Lezcano wrote:
> On 11/12/2012 01:28 PM, Thomas Gleixner wrote:
>> Dear RT Folks,
>>
>> I'm pleased to announce the 3.6.6-rt17 release. 3.6.6-rt16 is just a
>> not announced update release to 3.6.6.
> 
> Got this:
> 
> ----
> net/nfc/llcp/llcp.c: In function 'nfc_llcp_register_device':
> net/nfc/llcp/llcp.c:1185:24: error: expected expression before '{' token
> net/nfc/llcp/llcp.c:1186:35: error: expected expression before '{' token
> ----
> 
> when building with CONFIG_NFC / CONFIG_NFS_LLCP (builds fine when those 
> are not set)
> -- Fernando

Locking init is broken in llcp.  You'll need this commit from mainline.

commit fe235b58d517d623bf6d40c77afca1b0ee6fc85d
Author: Szymon Janc <szymon.janc@tieto.com>
Date:   Tue Sep 25 12:42:50 2012 +0200

    NFC: Use dynamic initialization for rwlocks
    
    If rwlock is dynamically allocated but statically initialized it is
    missing proper lockdep annotation.
    
    INFO: trying to register non-static key.
    the code is fine but needs lockdep annotation.
    turning off the locking correctness validator.
    Pid: 3352, comm: neard Not tainted 3.5.0-999-nfc+ #2
    Call Trace:
    [<ffffffff810c8526>] __lock_acquire+0x8f6/0x1bf0
    [<ffffffff81739045>] ? printk+0x4d/0x4f
    [<ffffffff810c9eed>] lock_acquire+0x9d/0x220
    [<ffffffff81702bfe>] ? nfc_llcp_sock_from_sn+0x4e/0x160
    [<ffffffff81746724>] _raw_read_lock+0x44/0x60
    [<ffffffff81702bfe>] ? nfc_llcp_sock_from_sn+0x4e/0x160
    [<ffffffff81702bfe>] nfc_llcp_sock_from_sn+0x4e/0x160
    [<ffffffff817034a7>] nfc_llcp_get_sdp_ssap+0xa7/0x1b0
    [<ffffffff81706353>] llcp_sock_bind+0x173/0x210
    [<ffffffff815d9c94>] sys_bind+0xe4/0x100
    [<ffffffff8139209e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
    [<ffffffff8174ea69>] system_call_fastpath+0x16/0x1b
    
    Signed-off-by: Szymon Janc <szymon.janc@tieto.com>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 90ef4a1..d649fbf 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -1156,8 +1156,8 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 
        INIT_WORK(&local->timeout_work, nfc_llcp_timeout_work);
 
-       local->sockets.lock = __RW_LOCK_UNLOCKED(local->sockets.lock);
-       local->connecting_sockets.lock = __RW_LOCK_UNLOCKED(local->connecting_sockets.lock);
+       rwlock_init(&local->sockets.lock);
+       rwlock_init(&local->connecting_sockets.lock);
 
        nfc_llcp_build_gb(local);
 



