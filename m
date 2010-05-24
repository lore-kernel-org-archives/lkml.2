Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0EXHeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:34:17 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:47851 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab0EXHeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:34:15 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 May 2010 03:34:15 EDT
X-AuditID: 83cfa826-b7cc7ae000001453-5a-4bfa286ff3d2
From: Yang Ruirui <ruirui.r.yang@tieto.com>
Organization: Tieto China
To: Michal Ostrowski <mostrows@earthlink.net>,
       "David S. Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] pppoe: initilize pppoe_pernet before usage
Date: Mon, 24 May 2010 15:19:46 +0800
User-Agent: KMail/1.11.4 (Linux/2.6.34-07097-gf4b87de; KDE/4.2.4; x86_64; ; )
CC: <hidave.darkstar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201005241519.47159.ruirui.r.yang@tieto.com>
X-Brightmail-Tracker: AAAAARRG6YE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ifconfig eth0 down in my kvm guest cause following oops, it's due to pppoe_net in
pppoe_flush_dev is not initilized:

[  137.163014] BUG: unable to handle kernel NULL pointer dereference at 0000000000000098         
[  137.163501] IP: [<ffffffff81060dad>] __lock_acquire+0x9f/0xe1f                                
[  137.163501] PGD 3f63067 PUD 7166067 PMD 0                                                     
[  137.163501] Oops: 0000 [#1] SMP                                                               
[  137.163501] last sysfs file: /sys/devices/virtual/vc/vcsa4/dev                                
[  137.163501] CPU 0                                                                             
[  137.163501] Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss fuse [last unloaded: 8139cp]     
[  137.163501]                                                                                   
[  137.163501] Pid: 1789, comm: ifconfig Not tainted 2.6.34-07097-gf4b87de #31 /Bochs            
[  137.163501] RIP: 0010:[<ffffffff81060dad>]  [<ffffffff81060dad>] __lock_acquire+0x9f/0xe1f    
[  137.163501] RSP: 0018:ffff8800071a3ad8  EFLAGS: 00010097                                      
[  137.163501] RAX: 0000000000000046 RBX: 0000000000000002 RCX: 0000000000000000                 
[  137.163501] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000098                 
[  137.163501] RBP: ffff8800071a3bd8 R08: 0000000000000002 R09: 0000000000000000                 
[  137.163501] R10: 0000000000000041 R11: ffff8800071a3dc8 R12: 0000000000000098                 
[  137.163501] R13: 0000000000000000 R14: ffff880007abd190 R15: 0000000000000000                 
[  137.163501] FS:  00007f1d8e1d96f0(0000) GS:ffff880002600000(0000) knlGS:0000000000000000      
[  137.163501] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                 
[  137.163501] CR2: 0000000000000098 CR3: 00000000071b6000 CR4: 00000000000006b0                 
[  137.163501] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                 
[  137.163501] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                 
[  137.163501] Process ifconfig (pid: 1789, threadinfo ffff8800071a2000, task ffff880007abd190)  
[  137.163501] Stack:                                                                            
[  137.163501]  ffff8800071a3b28 ffffffff8105f9ce 0000000000000002 0000000000000000              
[  137.163501] <0> ffff880000000000 ffffffff8105f9ce 0000000000000002 ffff880006902b30           
[  137.163501] <0> ffff8800071a3ba8 0000000000000002 ffff8800071a3b78 ffffffff8105f9ce           
[  137.163501] Call Trace:                                                                       
[  137.163501]  [<ffffffff8105f9ce>] ? mark_lock+0x22/0x261                                      
[  137.163501]  [<ffffffff8105f9ce>] ? mark_lock+0x22/0x261                                      
[  137.163501]  [<ffffffff8105f9ce>] ? mark_lock+0x22/0x261                                      
[  137.163501]  [<ffffffff81061b1e>] ? __lock_acquire+0xe10/0xe1f                                
[  137.163501]  [<ffffffff8105f9ce>] ? mark_lock+0x22/0x261                                      
[  137.163501]  [<ffffffff81061bff>] lock_acquire+0xd2/0xfe                                      
[  137.163501]  [<ffffffff813e2605>] ? pppoe_device_event+0x45/0x141                             
[  137.163501]  [<ffffffff8152a1f7>] _raw_write_lock_bh+0x31/0x3d                                
[  137.163501]  [<ffffffff813e2605>] ? pppoe_device_event+0x45/0x141                             
[  137.163501]  [<ffffffff813e2605>] pppoe_device_event+0x45/0x141                               
[  137.163501]  [<ffffffff8152db15>] notifier_call_chain+0x33/0x5b                               
[  137.163501]  [<ffffffff810537a4>] raw_notifier_call_chain+0xf/0x11                            
[  137.163501]  [<ffffffff81486dec>] call_netdevice_notifiers+0x45/0x4a                          
[  137.163501]  [<ffffffff8148727a>] __dev_close+0x5c/0x8a                                       
[  137.163501]  [<ffffffff8148501c>] __dev_change_flags+0xba/0x13c                               
[  137.163501]  [<ffffffff8148712b>] dev_change_flags+0x1c/0x51                                  
[  137.163501]  [<ffffffff814e0a0c>] devinet_ioctl+0x27f/0x565                                   
[  137.163501]  [<ffffffff814e1f1e>] inet_ioctl+0x92/0xaa                                        
[  137.163501]  [<ffffffff814761e2>] sock_ioctl+0x202/0x22c                                      
[  137.163501]  [<ffffffff810f22ac>] vfs_ioctl+0x2a/0x9e                                         
[  137.163501]  [<ffffffff810f2823>] do_vfs_ioctl+0x488/0x4b8                                    
[  137.163501]  [<ffffffff81052fb9>] ? up_read+0x1e/0x35                                         
[  137.163501]  [<ffffffff810029fa>] ? sysret_check+0x2e/0x69                                    
[  137.163501]  [<ffffffff810f28a8>] sys_ioctl+0x55/0x77                                         
[  137.163501]  [<ffffffff810029c2>] system_call_fastpath+0x16/0x1b                              
[  137.163501] Code: 0a 00 00 83 3d f4 9f 40 01 00 0f 84 ad 0c 00 00 e9 1d 0d 00 00 83 fe 07 76 11 e8 5b 2a 27 00 48 c7 c7 9c 95 7c 81 e9 d1 0c 00 00 <49> 81 3c 24 10 fb ba 81 b8 01 00 00 00 0f 44 d8 85 f6 75 0a 49                                                                             
[  137.163501] RIP  [<ffffffff81060dad>] __lock_acquire+0x9f/0xe1f                               
[  137.163501]  RSP <ffff8800071a3ad8>                                                           
[  137.163501] CR2: 0000000000000098                                                             
[  137.163501] ---[ end trace bc762774b58f37db ]---                                              
Fix it by add pppoe_pernet init code before pn usage

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
drivers/net/pppoe.c |    1 +
1 file changed, 1 insertion(+)

--- linux-2.6.orig/drivers/net/pppoe.c	2010-05-24 09:49:44.000000000 +0800
+++ linux-2.6/drivers/net/pppoe.c	2010-05-24 15:04:33.856666667 +0800
@@ -289,6 +289,7 @@ static void pppoe_flush_dev(struct net_d
 	struct pppoe_net *pn;
 	int i;
 
+	pn = pppoe_pernet(dev_net(dev));
 	write_lock_bh(&pn->hash_lock);
 	for (i = 0; i < PPPOE_HASH_SIZE; i++) {
 		struct pppox_sock *po = pn->hash_table[i];
