Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab0FTTKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 15:10:21 -0400
Received: from col0-omc1-s3.col0.hotmail.com ([65.55.34.13]:25488 "EHLO
	col0-omc1-s3.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423Ab0FTTKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 15:10:19 -0400
Message-ID: <COL124-W1850C30E9FF3BFB06DF5BFD6C20@phx.gbl>
Content-Type: multipart/mixed;
	boundary="_484662eb-033e-4825-96c0-ca4e50a23945_"
X-Originating-IP: [193.92.223.114]
From: =?iso-8859-7?B?wevd7uHt5PHv8iDQ4fDh5O/j6eHt7dzq5/I=?= 
	<psxlover@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: FW: sched_setaffinity not working with kernel 2.6.32.15
Date: Sun, 20 Jun 2010 22:10:18 +0300
Importance: Normal
MIME-Version: 1.0
X-OriginalArrivalTime: 20 Jun 2010 19:10:18.0120 (UTC) FILETIME=[38A8D880:01CB10AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_484662eb-033e-4825-96c0-ca4e50a23945_
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: 8bit


From: psxlover@hotmail.com
To: mingo@elte.hu; peterz@infradead.org
Subject:
 sched_setaffinity not working with kernel 2.6.32.15
Date: Sun, 20 
Jun 2010 17:14:12 +0300






.ExternalClass .ecxhmmessage P
{padding:0px;}
.ExternalClass body.ecxhmmessage
{font-size:10pt;font-family:Verdana;}



On kernel 2.6.32.15 after I execute sched_setaffinity even
though 
sched_getaffinity returns the right cpus the threads
of my program 
are running on different cpus.

  First time I came across the bug
 was on a PC on my unive-
rsity which had just been updated to Debian
 'squeeze'. I was
using a library calles hwloc to get information 
about the to-
pology of the system and bind threads to cpus. The 
binding
while it wasn't returning any error wasn't working (I used 
top
to check which cpus where being used). After contacting 
with 
the developers of hwloc they suggested that the pro-
blem is either 
in the kernel or in glibc.
  I made a virtual machine on my pc using 
the latest Debian
'squeeze' and the problem was there. So I tried an 
older
kernel I found in the Synaptic Package Manager and my pro-
gram
 was working fine. So the problem was in the kernel. I
e-mailed hwloc
 mailing list again and he suggested I tried
the vanilla kernels and 
use git bisect to find where the problem
started.
  With 2.6.34 
and 2.6.33.5 I had no problem but with 2.6.32.15
sched_setaffinity 
wasn't working. I used git bisect and in the 
end I got this:


c6fc81afa2d7ef2f775e48672693d8a0a8a7325d
 is the first bad commit
commit 
c6fc81afa2d7ef2f775e48672693d8a0a8a7325d
Author: John Wright 
<john.wright@hp.com>
Date:   Tue Apr 13 16:55:37 2010 -0600

   
 sched: Fix a race between ttwu() and migrate_task()
    
    
Based on commit e2912009fb7b715728311b0d8fe327a1432b3f79 upstream, but
   
 done differently as this issue is not present in .33 or .34 kernels due
   
 to rework in this area.
    
    If a task is in the TASK_WAITING
 state, then try_to_wake_up() is working
    on it, and it will place
 it on the correct cpu.
    
    This commit ensures that neither 
migrate_task() nor __migrate_task()
    calls set_task_cpu(p) while p
 is in the TASK_WAKING state.  Otherwise,
    there could be two 
concurrent calls to set_task_cpu(p), resulting in
    the task's 
cfs_rq being inconsistent with its cpu.
    
    Signed-off-by: 
John Wright <john.wright@hp.com>
    Cc: Ingo Molnar 
<mingo@elte.hu>
    Cc: Peter Zijlstra 
<peterz@infradead.org>
    Signed-off-by: Greg Kroah-Hartman 
<gregkh@suse.de>

:040000 040000 
a9d18950d8edddb761c0266706f671f0e9a006fe 
2c3a7d7d5e616ecc276b4e93f4b6e5162a9382c8 M    kernel


  I've 
attached a simple program that binds a few threads on
the first cpu. 
With 2.6.32.15 when I run it I can see with 
System Monitor that more
 than one cpu is being used by the
threads.


--------------------------
Alexandros
 Papadogiannakis 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with Microsoft's powerful SPAM protection.
https://signup.live.com/signup.aspx?id=60969
--_484662eb-033e-4825-96c0-ca4e50a23945_
Content-Type: text/x-csrc
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="test.c"

CiNpZm5kZWYgX0dOVV9TT1VSQ0UKI2RlZmluZSBfR05VX1NPVVJDRSAxCiNlbmRpZgoKI2luY2x1
ZGUgPHN0ZGlvLmg+Ci8vI2luY2x1ZGUgPHNjaGVkLmg+Ci8vI2luY2x1ZGUgPGh3bG9jLmg+CiNp
bmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHB0aHJlYWQuaD4KI2luY2x1ZGUgPHVuaXN0ZC5o
PgojaW5jbHVkZSA8c3lzL3R5cGVzLmg+CiNpbmNsdWRlIDxzeXMvc3lzY2FsbC5oPgoKI2RlZmlu
ZSBOUl9DUFVTIDgKI2RlZmluZSBOUl9USFJFQURTIDUKCnBpZF90IHRpZFtOUl9USFJFQURTXTsK
CnB0aHJlYWRfYmFycmllcl90IGluaXRfc3RhcnQsIGJhcnJpZXIyOwoKdm9pZCBwcmludF9hZmZp
bml0eShwdGhyZWFkX3QgcGlkLCBpbnQgdGhyZWFkbm8pIHsKCWludCBpOwoJY3B1X3NldF90IHNl
dDsKCQoJQ1BVX1pFUk8oJnNldCk7CgkKCXNjaGVkX2dldGFmZmluaXR5KCBwaWQsIHNpemVvZihz
ZXQpLCAmc2V0KTsgIAoKCQoJZm9yKCBpID0gMDsgaSA8IE5SX0NQVVM7IGkrKykgewoJCWlmIChD
UFVfSVNTRVQoaSwgJnNldCkpCgkJCXByaW50ZigiQ3B1ICMlZCBpcyBpbiAlZCB0aHJlYWQncyBh
ZmZpbml0eVxuIiwgaSwgdGhyZWFkbm8pOwoJfQp9Cgp2b2lkIHNldF9zY2hlZGFmZmluaXR5KHB0
aHJlYWRfdCBwaWQsIGludCBjcHUpIHsKCWNwdV9zZXRfdCBzZXQ7CgkKCUNQVV9aRVJPKCZzZXQp
OwoJQ1BVX1NFVChjcHUsICZzZXQpOwoJCglzY2hlZF9zZXRhZmZpbml0eShwaWQsIHNpemVvZihz
ZXQpLCAmc2V0KTsKfQoKdm9pZCBzZXRfdGhyZWFkYWZmaW5pdHkocHRocmVhZF90IHBpZCwgaW50
IGNwdSkgewoJY3B1X3NldF90IHNldDsKCQoJQ1BVX1pFUk8oJnNldCk7CglDUFVfU0VUKGNwdSwg
JnNldCk7CgkKCXB0aHJlYWRfc2V0YWZmaW5pdHlfbnAocGlkLCBzaXplb2Yoc2V0KSwgJnNldCk7
Cn0KCnZvaWQgKiB0aHJlYWRDb2RlKHZvaWQgKiB0aHJlYWRObykgewoJbG9uZyBpbnQgdGhyZWFk
ID0gKGxvbmcgaW50KSB0aHJlYWRObzsKCQoJLy9TZXQgY3VycmVudCB0aHJlYWQgaWQKCS8vdGlk
W3RocmVhZF0gPSAocGlkX3QpIHN5c2NhbGwgKFNZU19nZXR0aWQpOwoJCgkvL1dhaXQgZm9yIGFs
bCB0aGUgdGhyZWFkcyB0byBzZXQgdGhlaXIgdGhyZWFkIGlkCgkvL3B0aHJlYWRfYmFycmllcl93
YWl0KCZpbml0X3N0YXJ0KTsKCQoJLy9XYWl0IGZvciBtYWluIHRvIHNldCB0aGUgYWZmaW5pdHkK
CXB0aHJlYWRfYmFycmllcl93YWl0KCZiYXJyaWVyMik7CgkvL3NsZWVwKDEpOwoJCgkvL1ByaW50
IGFmZmluaXR5CglwcmludF9hZmZpbml0eSgwLHRocmVhZCk7CgkKCS8vRG8gc29tZXRoaW5nIHNv
IHRoYXQgd2UgY2FuIHNlZSBjcHUgYmVpbmcgdXNlZAoJd2hpbGUgKDEpOwoKCXB0aHJlYWRfZXhp
dCgwKTsKfQoKCgppbnQgbWFpbihpbnQgYXJnYyAsIGNoYXIgKmFyZ3ZbXSkgewoJbG9uZyBpbnQg
aTsKCXB0aHJlYWRfdCBwaWRbTlJfVEhSRUFEU107CgkKCS8vIEluaXRpYWxpemUgYmFycmllcnMK
CWlmKHB0aHJlYWRfYmFycmllcl9pbml0KCZpbml0X3N0YXJ0LCBOVUxMLCBOUl9USFJFQURTKSkg
ewoJCXByaW50ZigiQ291bGQgbm90IGNyZWF0ZSBhIGJhcnJpZXJcbiIpOwoJCWV4aXQoMSk7Cgl9
CglpZihwdGhyZWFkX2JhcnJpZXJfaW5pdCgmYmFycmllcjIsIE5VTEwsIE5SX1RIUkVBRFMpKSB7
CgkJcHJpbnRmKCJDb3VsZCBub3QgY3JlYXRlIGEgYmFycmllclxuIik7CgkJZXhpdCgxKTsKCX0K
CQoJLy9DcmVhdGUgdGhyZWFkcwoJZm9yIChpID0gMDsgaSA8IE5SX1RIUkVBRFM7IGkrKykKCQlw
dGhyZWFkX2NyZWF0ZSgmcGlkW2ldLCBOVUxMLCB0aHJlYWRDb2RlLCAodm9pZCAqKSBpKTsKCQoJ
Ly9XYWl0IGZvciB0aHJlYWRzIHRvIHNldCB0aGVpciB0aHJlYWQgaWQKCS8vcHRocmVhZF9iYXJy
aWVyX3dhaXQoJmluaXRfc3RhcnQpOwoJCgkvL1NldCBhZmZpbml0eQoJZm9yIChpID0gMDsgaSA8
IE5SX1RIUkVBRFM7IGkrKykKCQkvL3NldF9zY2hlZGFmZmluaXR5KHRpZFtpXSwxKTsKCQlzZXRf
dGhyZWFkYWZmaW5pdHkocGlkW2ldLDApOwoJCgkvL1RlbGwgdGhlIHRocmVhZHMgdG8gY29udGlu
dWUgYWZ0ZXIgc2V0dGluZyBhZmZpbml0eQoJLy9wdGhyZWFkX2JhcnJpZXJfd2FpdCgmYmFycmll
cjIpOwoJCglnZXRjaGFyKCk7IAoJCiAgICByZXR1cm4gMDsKfQoK

--_484662eb-033e-4825-96c0-ca4e50a23945_--
