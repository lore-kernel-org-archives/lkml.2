Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0ESXfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 19:35:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab0ESXfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 19:35:04 -0400
Message-ID: <4BF4757C.5090303@redhat.com>
Date: Wed, 19 May 2010 20:34:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: mmotm 2010-05-11-18-20 uploaded
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org> <6195.1273763194@localhost> <20100513160249.GC22238@core.coreip.homeip.net>
In-Reply-To: <20100513160249.GC22238@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Thu, May 13, 2010 at 11:06:34AM -0400, Valdis.Kletnieks@vt.edu wrote:
>> On Tue, 11 May 2010 18:21:22 PDT, akpm@linux-foundation.org said:
>>> The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>> Dell Latitude E6500, x86_64 kernel.
>>
>> Boots to single user prompt, but has issues on the way there.  Possibly
>> very important - I was definitely *not* typing at the time (as I had hit
>> return on the LUKS passphrase for the disk at 36 seconds after boot, and
>> I didn't get the # prompt for single-user for another minute or two (probably
>> due to udev having issues due to the oops). So I have no idea what it was
>> trying to get a keycode for...
>>
> 
> Udev probably tries to remap special keys on your keyboard...
> 
>> [   40.717136] udev: starting version 154
>> [   41.710153] BUG: unable to handle kernel NULL pointer dereference at (null)
>> [   41.711007] IP: [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b
>> [   41.711007] PGD 11d318067 PUD 118af1067 PMD 0
>> [   41.711007] Oops: 0002 [#1] PREEMPT SMP
>> [   41.711007] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4/idVendor
>> [   41.711007] CPU 0
>> [   41.711007] Modules linked in:
>> [   41.711007]
>> [   41.711007] Pid: 2501, comm: keymap Not tainted 2.6.34-rc7-mmotm0511 #2 0X564R/Latitude E6500
>>
>> [   41.711007] RIP: 0010:[<ffffffff813bb996>]  [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b
> 
> I think this is Mauro's big keycode additions.
> 

Ok, I was able to reproduce the bug:

# getkeycodes                                              
[22726.468755] BUG: unable to handle kernel NULL pointer dereference at (null)  
[22726.471074] IP: [<c138b6d0>] input_default_getkeycode_from_index+0x40/0x60   
[22726.471074] *pde = 00000000                                                  
[22726.471074] Oops: 0002 [#1] SMP                                              
[22726.471074] last sysfs file: /sys/devices/pci0000:00/0000:00:0b.1/usb1/1-3/dm
[22726.471074] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 ip6table_filter]
[22726.471074]                                                                  
[22726.471074] Pid: 947, comm: getkeycodes Not tainted 2.6.34 #6 C51MCP51/      
[22726.471074] EIP: 0060:[<c138b6d0>] EFLAGS: 00210046 CPU: 0                   
[22726.471074] EIP is at input_default_getkeycode_from_index+0x40/0x60          
[22726.471074] EAX: 00000000 EBX: 00000000 ECX: 00000002 EDX: dacfbdc8          
[22726.471074] ESI: dacfbdc8 EDI: f5daf794 EBP: dacfbdb8 ESP: dacfbdb4          
[22726.471074]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068                    
[22726.471074] Process getkeycodes (pid: 947, ti=dacfa000 task=f573d4a0 task.ti)
[22726.471074] Stack:                                                           
[22726.471074]  f5daf000 dacfbdec c138d233 dacfbe30 00200286 00000000 00000000 4
[22726.471074] <0> 00000000 00000000 00000000 dacfbe2c f5da0340 c16c12cc dacfbd8
[22726.471074] <0> c12f4130 dacfbe24 c138d9f8 00000002 00000001 00000000 c138d90
[22726.471074] Call Trace:                                                      
[22726.471074]  [<c138d233>] ? input_get_keycode+0x73/0x90                      
[22726.471074]  [<c12f4148>] ? getkeycode_helper+0x18/0x30                      
[22726.471074]  [<c12f4130>] ? getkeycode_helper+0x0/0x30                       
[22726.471074]  [<c138d9f8>] ? input_handler_for_each_handle+0x78/0xa0          
[22726.471074]  [<c138d980>] ? input_handler_for_each_handle+0x0/0xa0           
[22726.471074]  [<c12f4130>] ? getkeycode_helper+0x0/0x30                       
[22726.471074]  [<c12f399e>] ? getkeycode+0x2e/0x40                             
[22726.471074]  [<c12f16ab>] ? vt_ioctl+0xb9b/0x1960                            
[22726.471074]  [<c12ed600>] ? tty_ldisc_try+0x20/0x50                          
[22726.471074]  [<c12ed8da>] ? put_ldisc+0x4a/0xd0                              
[22726.471074]  [<c107649c>] ? trace_hardirqs_on_caller+0x12c/0x170             
[22726.471074]  [<c10764eb>] ? trace_hardirqs_on+0xb/0x10                       
[22726.471074]  [<c12f0b10>] ? vt_ioctl+0x0/0x1960                              
[22726.471074]  [<c12e74bf>] ? tty_ioctl+0x7f/0x8a0                             
[22726.471074]  [<c11150e2>] ? vfs_ioctl+0x32/0xc0                              
[22726.471074]  [<c12e7440>] ? tty_ioctl+0x0/0x8a0                              
[22726.471074]  [<c111584a>] ? do_vfs_ioctl+0x6a/0x5d0                          
[22726.471074]  [<c10fc455>] ? kmem_cache_free+0x85/0xc0                        
[22726.471074]  [<c107649c>] ? trace_hardirqs_on_caller+0x12c/0x170             
[22726.471074]  [<c10764eb>] ? trace_hardirqs_on+0xb/0x10                       
[22726.471074]  [<c111070b>] ? putname+0x2b/0x40                                
[22726.471074]  [<c1105523>] ? do_sys_open+0xf3/0x110                           
[22726.471074]  [<c1097f13>] ? audit_syscall_entry+0x1e3/0x210                  
[22726.471074]  [<c1115e17>] ? sys_ioctl+0x67/0x80                              
[22726.471074]  [<c1002fdf>] ? sysenter_do_call+0x12/0x38                       
[22726.471074] Code: 0a b8 ea ff ff ff 5b 5d c3 66 90 3b 98 a4 00 00 00 73 ee 8 
[22726.471074] EIP: [<c138b6d0>] input_default_getkeycode_from_index+0x40/0x60 4
[22726.471074] CR2: 0000000000000000                                            
[22726.471074] ---[ end trace 4ee8ba470bac54f1 ]---                             

I've removed the big getkeycode stuff from the material I've submitted earlier
today for 2.6.35. I'm currently working on fix the issue.

-- 

Cheers,
Mauro
