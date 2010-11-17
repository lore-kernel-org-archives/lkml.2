Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935175Ab0KQUxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:53:19 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53763 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab0KQUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:53:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=dlBN0tJaVMJVyy6FdvC7/T3F/SbOiOQAogv2RlF85gR2yu7IenOTAUc1cuOfp6Im1z
         l3YXqUjyX8SrJ13lMaqHCU9XYG+cBcpexarCcLhAZlqrXaX5qtfHZU0518Ok2shG9iP8
         hLC3mAQ+IjJ0rQRrqIKkabY/bh2Y00zIOXx8Q=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, martin.wilck@ts.fujitsu.com,
        jbarnes@virtuousgeek.org
Subject: [Regression] [2.6.37-rc2] WARNING: at drivers/pci/pci-sysfs.c:758 pci_mmap_resource+0x133/0x190()
Date: Wed, 17 Nov 2010 21:53:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011172153.11313.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 2.6.37-rc1
Bad kernel: 2.6.37-rc2
Hardware: VirtualBox

Description: cannot run Xwindow, booting hangs on this kernel message:
[  143.502215] ------------[ cut here ]------------                                                              
[  143.503050] WARNING: at drivers/pci/pci-sysfs.c:758 
pci_mmap_resource+0x133/0x190()                           
[  143.523361] Hardware name: VirtualBox                                                                         
[  143.523387] process "Xorg" tried to map 0x02000000 bytes at page 0x00000000 
on 0000:00:02.0 BAR 0 (start 0x   
[  143.523408] Modules linked in: fuse loop sha256_generic aes_i586 
aes_generic cbc dm_crypt dm_mod ohci_hcd ehci
[  143.523823] Pid: 1665, comm: Xorg Not tainted 2.6.37-rc2 #1                                                   
[  143.523843] Call Trace:                                                                                       
[  143.523878]  [<c0137f9d>] warn_slowpath_common+0x6d/0xa0                                                      
[  143.523898]  [<c0281c83>] ? pci_mmap_resource+0x133/0x190                                                     
[  143.523916]  [<c0281c83>] ? pci_mmap_resource+0x133/0x190                                                     
[  143.523935]  [<c013804e>] warn_slowpath_fmt+0x2e/0x30                                                         
[  143.523953]  [<c0281c83>] pci_mmap_resource+0x133/0x190                                                       
[  143.523972]  [<c0281ce0>] ? pci_mmap_resource_uc+0x0/0x20                                                     
[  143.524000]  [<c0281cf9>] pci_mmap_resource_uc+0x19/0x20                                                      
[  143.526472]  [<c020eba2>] mmap+0x62/0x100                                                                     
[  143.526501]  [<c01ac52f>] mmap_region+0x2bf/0x410                                                             
[  143.526522]  [<c01ac8dc>] do_mmap_pgoff+0x25c/0x300                                                           
[  143.526541]  [<c01aca17>] sys_mmap_pgoff+0x97/0x130                                                           
[  143.526569]  [<c03dbd11>] syscall_call+0x7/0xb                                                                
[  143.526584] ---[ end trace 57cafb32c03e0f5f ]---

Bisection shows:
3b519e4ea618b6943a82931630872907f9ac2c2b is the first bad commit                                                 
commit 3b519e4ea618b6943a82931630872907f9ac2c2b                                                                  
Author: Martin Wilck <martin.wilck@ts.fujitsu.com>                                                               
Date:   Wed Nov 10 11:03:21 2010 +0100                                                                           
                                                                                                                 
    PCI: fix size checks for mmap() on /proc/bus/pci files                                                       
                                                                                                                 
    The checks for valid mmaps of PCI resources made through /proc/bus/pci 
files                                 
    that were introduced in 9eff02e2042f96fb2aedd02e032eca1c5333d767 have 
several                                
    problems:                                                                                                    
                                                                                                                 
    1. mmap() calls on /proc/bus/pci files are made with real file offsets > 
0,                                  
    whereas under /sys/bus/pci/devices, the start of the resource corresponds                                    
    to offset 0. This may lead to false negatives in pci_mmap_fits(), which                                      
    implicitly assumes the /sys/bus/pci/devices layout.                                                          
                                                                                                                 
    2. The loop in proc_bus_pci_mmap doesn't skip empty resouces. This leads                                     
    to false positives, because pci_mmap_fits() doesn't treat empty resources                                    
    correctly (the calculated size is 1 << (8*sizeof(resource_size_t)-
PAGE_SHIFT)                                
    in this case!).                                                                                              
                                                                                                                 
    3. If a user maps resources with BAR > 0, pci_mmap_fits will emit bogus                                      
    WARNINGS for the first resources that don't fit until the correct one is 
found.                              
                                                                                                                 
    On many controllers the first 2-4 BARs are used, and the others are empty.                                   
    In this case, an mmap attempt will first fail on the non-empty BARs                                          
    (including the "right" BAR because of 1.) and emit bogus WARNINGS because                                    
    of 3., and finally succeed on the first empty BAR because of 2.                                              
    This is certainly not the intended behaviour.

   This patch addresses all 3 issues.                                                                            
   Updated with an enum type for the additional parameter for pci_mmap_fits().                                   
                                                                                                                 
   Cc: stable@kernel.org                                                                                         
   Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>                                                     
   Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>                                                        
                                                                                                                 
040000 040000 73eda4a589e4b0da691202a36ec4b7e38f635c64 
2dd7820cdcff8b2d1e23d990eee7a5832a356c38 M      drivers

Full dmesg:
http://unixy.pl/maciek/download/kernel/2.6.37-rc2/vbox/dmesg-2.6.37-rc2.txt

Config:
http://unixy.pl/maciek/download/kernel/2.6.37-rc2/vbox/config-2.6.37-rc2

lspci:
http://unixy.pl/maciek/download/kernel/2.6.37-rc2/vbox/lspci.txt

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
