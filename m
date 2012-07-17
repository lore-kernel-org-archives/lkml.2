Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2GQDTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:19:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59896 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2GQDTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:19:19 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5004D8BF.6050205@jp.fujitsu.com>
Date: Tue, 17 Jul 2012 12:15:11 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: amwang@redhat.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        xiyou.wangcong@gmail.com, dyoung@redhat.com, hpa@zytor.com,
        rjw@sisk.pl, yinghai.lu@oracle.com, tiwai@suse.de
Subject: Re: [PATCH] x86: revert "x86: Fix S4 regression"
References: <1339478463-31172-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1339478463-31172-1-git-send-email-amwang@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------050401020800040805060406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050401020800040805060406
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi Cong,

When I tested kdump with 3.5.0-rc6 kernel, I found a problem of kdump
kernel's panic in find_early_table_space().

init_memory_mapping: [mem 0x00000000-0x36ffafff]
Kernel panic - not syncing: Cannot find space for the kernel page tables
Pid: 0, comm: swapper Not tainted 3.5.0-rc6 #17
Call Trace:
 [<ffffffff8158549b>] panic+0xb8/0x1c8
 [<ffffffff8158565d>] ? printk+0x48/0x4a
 [<ffffffff8157304c>] init_memory_mapping+0x46c/0x530
 [<ffffffff818a73c7>] setup_arch+0x669/0xb0e
 [<ffffffff8158565d>] ? printk+0x48/0x4a
 [<ffffffff818a3a1f>] start_kernel+0x9b/0x34a
 [<ffffffff818a332d>] x86_64_start_reservations+0x131/0x136
 [<ffffffff818a341f>] x86_64_start_kernel+0xed/0xf4

In find_early_table_space(), a kernel tries to find free area below 512M
for pgtable using memblock_find_in_range, but it fails because kdump
kernel does not have enough free space below 512M due to the memmap
restriction. This is the memmap option specified against kdump kernel
when crashkernel=128M.

memmap=560K@64K memmap=130492K@770608K

Only 560KB area is available and it is not sufficient for pgtable (it
seems that about 1.8MB area is needed for pgtable). This problem is
fixed by your revert patch. I hope this patch gets merged.

Thanks,
Takao Indoh

(2012/06/12 14:21), Cong Wang wrote:
> From: Cong Wang <xiyou.wangcong@gmail.com>
> 
> This reverts the following commit:
> 
> 	commit 8548c84da2f47e71bbbe300f55edb768492575f7
> 	Author: Takashi Iwai <tiwai@suse.de>
> 	Date:   Sun Oct 23 23:19:12 2011 +0200
> 
> 	    x86: Fix S4 regression
> 	
> 	    Commit 4b239f458 ("x86-64, mm: Put early page table high") causes a S4
> 	    regression since 2.6.39, namely the machine reboots occasionally at S4
> 	    resume.  It doesn't happen always, overall rate is about 1/20.  But,
> 	    like other bugs, once when this happens, it continues to happen.
> 	
> 	    This patch fixes the problem by essentially reverting the memory
> 	    assignment in the older way.
> 
> According to the previous discussion:
> http://marc.info/?l=linux-kernel&m=133161674120253&w=2
> it seems that so far the best solution is just reverting it.
> 
> Takashi, could you help to test if the S4 regression is still
> there after this patch?
> 
> Reported-by: CAI Qian <caiqian@redhat.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Yinghai Lu <yinghai.lu@oracle.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> 
> ---
>   arch/x86/mm/init.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index bc4e9d8..7ab7975 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -74,8 +74,9 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
>   #ifdef CONFIG_X86_32
>   	/* for fixmap */
>   	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
> -#endif
> +
>   	good_end = max_pfn_mapped << PAGE_SHIFT;
> +#endif
>   
>   	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
>   	if (!base)
> 

--------------050401020800040805060406
Content-Type: text/plain; charset=Shift_JIS;
 name="log.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="log.txt"

WyAgICAwLjAwMDAwMF0gTGludXggdmVyc2lvbiAzLjUuMC1yYzYgKHJvb3RAbG9jYWxob3N0
KSAoZ2NjIHZlcnNpb24gNC40LjYgMjAxMjAzMDUgKFJlZCBIYXQgNC40LjYtNCkgKEdDQykg
KSAjMTcgU01QIFRodSBKdWwgMTIgMTM6NDk6NDYgSlNUIDIwMTINClsgICAgMC4wMDAwMDBd
IENvbW1hbmQgbGluZTogcm8gcm9vdD1VVUlEPTE4OTNhMTNlLTE5YWYtNDM5Yi05ZDM5LTBh
NDIyNjBmM2VhYSByZF9OT19MVUtTIHJkX05PX01EIEtFWUJPQVJEVFlQRT1wYyBLRVlUQUJM
RT1qcDEwNiBMQU5HPWphX0pQLlVURi04IHJkX05PX0xWTSByZF9OT19ETSBsb2dsZXZlbD03
IGVhcmx5cHJpbnRrPXNlcmlhbCx0dHlTMCwxOTIwMG44IGlycXBvbGwgbnJfY3B1cz0xIHJl
c2V0X2RldmljZXMgY2dyb3VwX2Rpc2FibGU9bWVtb3J5IG1jZT1vZmYgIG1lbW1hcD1leGFj
dG1hcCBtZW1tYXA9NTYwS0A2NEsgbWVtbWFwPTEzMDQ5MktANzcwNjA4SyBlbGZjb3JlaGRy
PTkwMTEwMEsgbWVtbWFwPTY0SyQwSyBtZW1tYXA9MTZLJDYyNEsgbWVtbWFwPTExMkskOTEy
SyBtZW1tYXA9MzI4MzJLJDMxMDMzNjBLIG1lbW1hcD00MEsjMzEzNjE5MksgbWVtbWFwPTRL
IzMxMzYyMzJLIG1lbW1hcD05NDkySyQzMTM2MjM2SyBtZW1tYXA9MjYyMTQ0SyQzNjcwMDE2
SyBtZW1tYXA9MTAyNEskNDE3MzgyNEsgbWVtbWFwPTRLJDQxNzU4NzJLIG1lbW1hcD0xNzQw
OEskNDE3Njg5NksNClsgICAgMC4wMDAwMDBdIGU4MjA6IEJJT1MtcHJvdmlkZWQgcGh5c2lj
YWwgUkFNIG1hcDoNClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAw
MDAwMDAxMDAtMHgwMDAwMDAwMDAwMDliZmZmXSB1c2FibGUNClsgICAgMC4wMDAwMDBdIEJJ
T1MtZTgyMDogW21lbSAweDAwMDAwMDAwMDAwOWMwMDAtMHgwMDAwMDAwMDAwMDlmZmZmXSBy
ZXNlcnZlZA0KWyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDAwMDBl
NDAwMC0weDAwMDAwMDAwMDAwZmZmZmZdIHJlc2VydmVkDQpbICAgIDAuMDAwMDAwXSBCSU9T
LWU4MjA6IFttZW0gMHgwMDAwMDAwMDAwMTAwMDAwLTB4MDAwMDAwMDBiZDY5ZmZmZl0gdXNh
YmxlDQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGJkNmEwMDAw
LTB4MDAwMDAwMDBiZjZhZmZmZl0gcmVzZXJ2ZWQNClsgICAgMC4wMDAwMDBdIEJJT1MtZTgy
MDogW21lbSAweDAwMDAwMDAwYmY2YjAwMDAtMHgwMDAwMDAwMGJmNmI5ZmZmXSBBQ1BJIGRh
dGENClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwYmY2YmEwMDAt
MHgwMDAwMDAwMGJmNmJhZmZmXSBBQ1BJIE5WUw0KWyAgICAwLjAwMDAwMF0gQklPUy1lODIw
OiBbbWVtIDB4MDAwMDAwMDBiZjZiYjAwMC0weDAwMDAwMDAwYmZmZmZmZmZdIHJlc2VydmVk
DQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGUwMDAwMDAwLTB4
MDAwMDAwMDBlZmZmZmZmZl0gcmVzZXJ2ZWQNClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDog
W21lbSAweDAwMDAwMDAwZmVjMDAwMDAtMHgwMDAwMDAwMGZlY2ZmZmZmXSByZXNlcnZlZA0K
WyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBmZWUwMDAwMC0weDAw
MDAwMDAwZmVlMDBmZmZdIHJlc2VydmVkDQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFtt
ZW0gMHgwMDAwMDAwMGZmYTAwMDAwLTB4MDAwMDAwMDBmZmZmZmZmZl0gcmVzZXJ2ZWQNClsg
ICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAxMDAwMDAwMDAtMHgwMDAw
MDAwNDNmZmZmZmZmXSB1c2FibGUNClsgICAgMC4wMDAwMDBdIGJvb3Rjb25zb2xlIFtlYXJs
eXNlcjBdIGVuYWJsZWQNClsgICAgMC4wMDAwMDBdIGU4MjA6IGxhc3RfcGZuID0gMHg0NDAw
MDAgbWF4X2FyY2hfcGZuID0gMHg0MDAwMDAwMDANClsgICAgMC4wMDAwMDBdIE5YIChFeGVj
dXRlIERpc2FibGUpIHByb3RlY3Rpb246IGFjdGl2ZQ0KWyAgICAwLjAwMDAwMF0gZTgyMDog
dXNlci1kZWZpbmVkIHBoeXNpY2FsIFJBTSBtYXA6DQpbICAgIDAuMDAwMDAwXSB1c2VyOiBb
bWVtIDB4MDAwMDAwMDAwMDAwMDAwMC0weDAwMDAwMDAwMDAwMGZmZmZdIHJlc2VydmVkDQpb
ICAgIDAuMDAwMDAwXSB1c2VyOiBbbWVtIDB4MDAwMDAwMDAwMDAxMDAwMC0weDAwMDAwMDAw
MDAwOWJmZmZdIHVzYWJsZQ0KWyAgICAwLjAwMDAwMF0gdXNlcjogW21lbSAweDAwMDAwMDAw
MDAwOWMwMDAtMHgwMDAwMDAwMDAwMDlmZmZmXSByZXNlcnZlZA0KWyAgICAwLjAwMDAwMF0g
dXNlcjogW21lbSAweDAwMDAwMDAwMDAwZTQwMDAtMHgwMDAwMDAwMDAwMGZmZmZmXSByZXNl
cnZlZA0KWyAgICAwLjAwMDAwMF0gdXNlcjogW21lbSAweDAwMDAwMDAwMmYwOGMwMDAtMHgw
MDAwMDAwMDM2ZmZhZmZmXSB1c2FibGUNClsgICAgMC4wMDAwMDBdIHVzZXI6IFttZW0gMHgw
MDAwMDAwMGJkNmEwMDAwLTB4MDAwMDAwMDBiZjZhZmZmZl0gcmVzZXJ2ZWQNClsgICAgMC4w
MDAwMDBdIHVzZXI6IFttZW0gMHgwMDAwMDAwMGJmNmIwMDAwLTB4MDAwMDAwMDBiZjZiYWZm
Zl0gQUNQSSBkYXRhDQpbICAgIDAuMDAwMDAwXSB1c2VyOiBbbWVtIDB4MDAwMDAwMDBiZjZi
YjAwMC0weDAwMDAwMDAwYmZmZmZmZmZdIHJlc2VydmVkDQpbICAgIDAuMDAwMDAwXSB1c2Vy
OiBbbWVtIDB4MDAwMDAwMDBlMDAwMDAwMC0weDAwMDAwMDAwZWZmZmZmZmZdIHJlc2VydmVk
DQpbICAgIDAuMDAwMDAwXSB1c2VyOiBbbWVtIDB4MDAwMDAwMDBmZWMwMDAwMC0weDAwMDAw
MDAwZmVjZmZmZmZdIHJlc2VydmVkDQpbICAgIDAuMDAwMDAwXSB1c2VyOiBbbWVtIDB4MDAw
MDAwMDBmZWUwMDAwMC0weDAwMDAwMDAwZmVlMDBmZmZdIHJlc2VydmVkDQpbICAgIDAuMDAw
MDAwXSB1c2VyOiBbbWVtIDB4MDAwMDAwMDBmZWYwMDAwMC0weDAwMDAwMDAwZmZmZmZmZmZd
IHJlc2VydmVkDQpbICAgIDAuMDAwMDAwXSBETUkgcHJlc2VudC4NClsgICAgMC4wMDAwMDBd
IE5vIEFHUCBicmlkZ2UgZm91bmQNClsgICAgMC4wMDAwMDBdIGU4MjA6IGxhc3RfcGZuID0g
MHgzNmZmYiBtYXhfYXJjaF9wZm4gPSAweDQwMDAwMDAwMA0KWyAgICAwLjAwMDAwMF0geDg2
IFBBVCBlbmFibGVkOiBjcHUgMCwgb2xkIDB4NzAxMDYwMDA3MDEwNiwgbmV3IDB4NzAxMDYw
MDA3MDEwNg0KWyAgICAwLjAwMDAwMF0gZm91bmQgU01QIE1QLXRhYmxlIGF0IFttZW0gMHgw
MDBmN2VmMC0weDAwMGY3ZWZmXSBtYXBwZWQgYXQgW2ZmZmY4ODAwMDAwZjdlZjBdDQpbICAg
IDAuMDAwMDAwXSBVc2luZyBHQiBwYWdlcyBmb3IgZGlyZWN0IG1hcHBpbmcNClsgICAgMC4w
MDAwMDBdIGluaXRfbWVtb3J5X21hcHBpbmc6IFttZW0gMHgwMDAwMDAwMC0weDM2ZmZhZmZm
XQ0KWyAgICAwLjAwMDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IENhbm5vdCBm
aW5kIHNwYWNlIGZvciB0aGUga2VybmVsIHBhZ2UgdGFibGVzDQpbICAgIDAuMDAwMDAwXSBQ
aWQ6IDAsIGNvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy41LjAtcmM2ICMxNw0KWyAgICAw
LjAwMDAwMF0gQ2FsbCBUcmFjZToNClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODE1ODU0
OWI+XSBwYW5pYysweGI4LzB4MWM4DQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxNTg1
NjVkPl0gPyBwcmludGsrMHg0OC8weDRhDQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgx
NTczMDRjPl0gaW5pdF9tZW1vcnlfbWFwcGluZysweDQ2Yy8weDUzMA0KWyAgICAwLjAwMDAw
MF0gIFs8ZmZmZmZmZmY4MThhNzNjNz5dIHNldHVwX2FyY2grMHg2NjkvMHhiMGUNClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODE1ODU2NWQ+XSA/IHByaW50aysweDQ4LzB4NGENClsg
ICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODE4YTNhMWY+XSBzdGFydF9rZXJuZWwrMHg5Yi8w
eDM0YQ0KWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MThhMzMyZD5dIHg4Nl82NF9zdGFy
dF9yZXNlcnZhdGlvbnMrMHgxMzEvMHgxMzYNClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZm
ODE4YTM0MWY+XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4ZWQvMHhmNA0KUEFOSUM6IGVhcmx5
IGV4Y2VwdGlvbiAwZCByaXAgMTA6ZmZmZmZmZmY4MTU4NTU2ZCBlcnJvciA3N2IgY3IyIDAN
ClsgICAgMC4wMDAwMDBdIFBpZDogMCwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjUu
MC1yYzYgIzE3DQpbICAgIDAuMDAwMDAwXSBDYWxsIFRyYWNlOg0KWyAgICAwLjAwMDAwMF0g
IFs8ZmZmZmZmZmY4MTU4NTU2ZD5dID8gcGFuaWMrMHgxOGEvMHgxYzgNClsgICAgMC4wMDAw
MDBdICBbPGZmZmZmZmZmODE4YTMxODQ+XSBlYXJseV9pZHRfaGFuZGxlcisweDY0LzB4OTQN
ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODE1ODU1NmQ+XSA/IHBhbmljKzB4MThhLzB4
MWM4DQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxNTg1NGQwPl0gPyBwYW5pYysweGVk
LzB4MWM4DQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxNTg1NjVkPl0gPyBwcmludGsr
MHg0OC8weDRhDQpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxNTczMDRjPl0gaW5pdF9t
ZW1vcnlfbWFwcGluZysweDQ2Yy8weDUzMA0KWyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4
MThhNzNjNz5dIHNldHVwX2FyY2grMHg2NjkvMHhiMGUNClsgICAgMC4wMDAwMDBdICBbPGZm
ZmZmZmZmODE1ODU2NWQ+XSA/IHByaW50aysweDQ4LzB4NGENClsgICAgMC4wMDAwMDBdICBb
PGZmZmZmZmZmODE4YTNhMWY+XSBzdGFydF9rZXJuZWwrMHg5Yi8weDM0YQ0KWyAgICAwLjAw
MDAwMF0gIFs8ZmZmZmZmZmY4MThhMzMyZD5dIHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMr
MHgxMzEvMHgxMzYNClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODE4YTM0MWY+XSB4ODZf
NjRfc3RhcnRfa2VybmVsKzB4ZWQvMHhmNA0KWyAgICAwLjAwMDAwMF0gUklQIDB4MA0K
--------------050401020800040805060406--

