Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab1KDFxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 01:53:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63414 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1KDFxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 01:53:42 -0400
MIME-Version: 1.0
In-Reply-To: <4EB2D225.60808@linux.vnet.ibm.com>
References: <1320317323.5711.5.camel@localhost.localdomain>
	<1320321770.2813.10.camel@hp6530s>
	<4EB2D225.60808@linux.vnet.ibm.com>
Date: Fri, 4 Nov 2011 11:53:39 +0600
Message-ID: <CADZ9YHiht68YLz5eWc0xc8R3bxLrgdf4sxgLBwODiKoLQLU7FQ@mail.gmail.com>
Subject: Re: [PATCH -v1] acpi: Fix possible recursive locking in hwregs.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Lin Ming <ming.m.lin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>
Content-Type: multipart/mixed; boundary=20cf3040ee1caf682104b0e253db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3040ee1caf682104b0e253db
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Nov 3, 2011 at 11:40 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Hi,
>
> On 11/03/2011 05:32 PM, Lin Ming wrote:
>> On Thu, 2011-11-03 at 18:48 +0800, Rakib Mullick wrote:
>>> Calling pm-suspend might trigger a recursive lock in it's code path. In function acpi_hw_clear_acpi_status,
>>
>> As I replied at https://lkml.org/lkml/2011/9/22/6, I still don't think
>> there is a recursive lock.
>>
>
> At first look, it definitely doesn't look like a recursive lock, as Lin said.
> But, quoting Documentation/lockdep-design.txt:
>
> "Multi-lock dependency rules:
> ----------------------------
>
> The same lock-class must not be acquired twice, because this could lead
> to lock recursion deadlocks."
>
> So, Rakib, do the 2 locks belong to the same lock-class? If yes, then I think
> that is the reason for the lockdep splat. Could you show the lockdep warning?
>
Yes, same lock-class. And as per "Multi-lock dependency rules:", it
leads to lock recursion deadlocks.
Lockdep warning attached.

> By the way, another way to look at this patch is as an optimization..
> i.e., if acpi_gbl_hardware_lock doesn't need to be held to call
> acpi_ev_walk_gpe_list(), then we can move from the coarse-grained locking
> to finer-grained locking by releasing it earlier, as you did in your patch.
> [Note that you will have to update the goto label also, i.e., rename it as
> 'exit' or something like that]
>
I can do it, thanks for suggestions. But, what does Lin thinks? Lin
are you okay?

Thanks,
Rakib

--20cf3040ee1caf682104b0e253db
Content-Type: application/octet-stream; name=lockdepwarning
Content-Disposition: attachment; filename=lockdepwarning
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gukrp6s50

WyA1Mzg3LjczNDA3OV0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09ClsgNTM4Ny43MzQwODJdIFsgSU5GTzogcG9zc2libGUgcmVjdXJzaXZlIGxvY2tpbmcgZGV0
ZWN0ZWQgXQpbIDUzODcuNzM0MDg1XSAzLjAuMC1yYzMtdGlwLW1yLmJhcmJlcisgIzQKWyA1Mzg3
LjczNDA4N10gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsg
NTM4Ny43MzQwODldIHBtLXN1c3BlbmQvOTYwMCBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpb
IDUzODcuNzM0MDkyXSAgKCYobG9jayktPnJsb2NrKXstLi0uLi59LCBhdDogWzxmZmZmZmZmZjgx
MjhlODdkPl0gYWNwaV9vc19hY3F1aXJlX2xvY2srMHhlLzB4MTAKWyA1Mzg3LjczNDEwM10gClsg
NTM4Ny43MzQxMDNdIGJ1dCB0YXNrIGlzIGFscmVhZHkgaG9sZGluZyBsb2NrOgpbIDUzODcuNzM0
MTA1XSAgKCYobG9jayktPnJsb2NrKXstLi0uLi59LCBhdDogWzxmZmZmZmZmZjgxMjhlODdkPl0g
YWNwaV9vc19hY3F1aXJlX2xvY2srMHhlLzB4MTAKWyA1Mzg3LjczNDExMF0gClsgNTM4Ny43MzQx
MTFdIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgNTM4Ny43MzQx
MTNdICBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJpbzoKWyA1Mzg3LjczNDExNF0gClsg
NTM4Ny43MzQxMTVdICAgICAgICBDUFUwClsgNTM4Ny43MzQxMTddICAgICAgICAtLS0tClsgNTM4
Ny43MzQxMTldICAgbG9jaygmKGxvY2spLT5ybG9jayk7ClsgNTM4Ny43MzQxMjFdICAgbG9jaygm
KGxvY2spLT5ybG9jayk7ClsgNTM4Ny43MzQxMjRdIApbIDUzODcuNzM0MTI1XSAgKioqIERFQURM
T0NLICoqKgpbIDUzODcuNzM0MTI2XSAKWyA1Mzg3LjczNDEyN10gIE1heSBiZSBkdWUgdG8gbWlz
c2luZyBsb2NrIG5lc3Rpbmcgbm90YXRpb24KWyA1Mzg3LjczNDEyOF0gClsgNTM4Ny43MzQxMzBd
IDQgbG9ja3MgaGVsZCBieSBwbS1zdXNwZW5kLzk2MDA6ClsgNTM4Ny43MzQxMzFdICAjMDogICgm
YnVmZmVyLT5tdXRleCl7Ky4rLisufSwgYXQ6IFs8ZmZmZmZmZmY4MTE4NmQwZD5dIHN5c2ZzX3dy
aXRlX2ZpbGUrMHgzYy8weDE1ZApbIDUzODcuNzM0MTQxXSAgIzE6ICAoc19hY3RpdmUjODkpey4r
LisuK30sIGF0OiBbPGZmZmZmZmZmODExODZkZDE+XSBzeXNmc193cml0ZV9maWxlKzB4MTAwLzB4
MTVkClsgNTM4Ny43MzQxNDhdICAjMjogIChwbV9tdXRleCl7Ky4rLisufSwgYXQ6IFs8ZmZmZmZm
ZmY4MTA4ZWQ0ZT5dIGVudGVyX3N0YXRlKzB4MzkvMHgxM2MKWyA1Mzg3LjczNDE1Nl0gICMzOiAg
KCYobG9jayktPnJsb2NrKXstLi0uLi59LCBhdDogWzxmZmZmZmZmZjgxMjhlODdkPl0gYWNwaV9v
c19hY3F1aXJlX2xvY2srMHhlLzB4MTAKWyA1Mzg3LjczNDE2Ml0gClsgNTM4Ny43MzQxNjJdIHN0
YWNrIGJhY2t0cmFjZToKWyA1Mzg3LjczNDE2Nl0gUGlkOiA5NjAwLCBjb21tOiBwbS1zdXNwZW5k
IE5vdCB0YWludGVkIDMuMC4wLXJjMy10aXAtbXIuYmFyYmVyKyAjNApbIDUzODcuNzM0MTY4XSBD
YWxsIFRyYWNlOgpbIDUzODcuNzM0MTc1XSAgWzxmZmZmZmZmZjgxMDgxMGE0Pl0gX19sb2NrX2Fj
cXVpcmUrMHg5YTIvMHhkYzEKWyA1Mzg3LjczNDE4MF0gIFs8ZmZmZmZmZmY4MTA4MDIyYT5dID8g
Y2hlY2tfaXJxX3VzYWdlKzB4NzgvMHg4OQpbIDUzODcuNzM0MTgzXSAgWzxmZmZmZmZmZjgxMjhl
ODdkPl0gPyBhY3BpX29zX2FjcXVpcmVfbG9jaysweGUvMHgxMApbIDUzODcuNzM0MTg3XSAgWzxm
ZmZmZmZmZjgxMDgxOTZlPl0gbG9ja19hY3F1aXJlKzB4Y2UvMHhmOQpbIDUzODcuNzM0MTkwXSAg
WzxmZmZmZmZmZjgxMjhlODdkPl0gPyBhY3BpX29zX2FjcXVpcmVfbG9jaysweGUvMHgxMApbIDUz
ODcuNzM0MTk1XSAgWzxmZmZmZmZmZjgxMmE2NTNjPl0gPyBhY3BpX2h3X2VuYWJsZV9ydW50aW1l
X2dwZV9ibG9jaysweDQ4LzB4NDgKWyA1Mzg3LjczNDE5OV0gIFs8ZmZmZmZmZmY4MTJhNjUzYz5d
ID8gYWNwaV9od19lbmFibGVfcnVudGltZV9ncGVfYmxvY2srMHg0OC8weDQ4ClsgNTM4Ny43MzQy
MDddICBbPGZmZmZmZmZmODE1ZGUyNzU+XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4M2YvMHg1
MgpbIDUzODcuNzM0MjEwXSAgWzxmZmZmZmZmZjgxMjhlODdkPl0gPyBhY3BpX29zX2FjcXVpcmVf
bG9jaysweGUvMHgxMApbIDUzODcuNzM0MjE0XSAgWzxmZmZmZmZmZjgxMjhlODdkPl0gYWNwaV9v
c19hY3F1aXJlX2xvY2srMHhlLzB4MTAKWyA1Mzg3LjczNDIyMF0gIFs8ZmZmZmZmZmY4MTI5ZmFj
Yz5dIGFjcGlfZXZfd2Fsa19ncGVfbGlzdCsweDI4LzB4OTIKWyA1Mzg3LjczNDIyNF0gIFs8ZmZm
ZmZmZmY4MTJhNmMzMT5dIGFjcGlfaHdfY2xlYXJfYWNwaV9zdGF0dXMrMHgzZS8weDVkClsgNTM4
Ny43MzQyMjddICBbPGZmZmZmZmZmODEyYTcwMGM+XSBhY3BpX2VudGVyX3NsZWVwX3N0YXRlKzB4
OTAvMHgxY2QKWyA1Mzg3LjczNDIzNF0gIFs8ZmZmZmZmZmY4MTAxMTlkMj5dID8gc2NoZWRfY2xv
Y2srMHg5LzB4ZApbIDUzODcuNzM0MjM4XSAgWzxmZmZmZmZmZjgxMDExZWFlPl0gPyBzYXZlX3Nj
aGVkX2Nsb2NrX3N0YXRlKzB4MTIvMHgxYgpbIDUzODcuNzM0MjQ0XSAgWzxmZmZmZmZmZjgxNDZm
MzBlPl0gPyBzYXZlX3Byb2Nlc3Nvcl9zdGF0ZSsweDE5ZS8weDFhZQpbIDUzODcuNzM0MjQ4XSAg
WzxmZmZmZmZmZjgxNWRlODRkPl0gPyBfcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUrMHgzZS8w
eDUyClsgNTM4Ny43MzQyNTNdICBbPGZmZmZmZmZmODEwMjJhYWE+XSBkb19zdXNwZW5kX2xvd2xl
dmVsKzB4OWEvMHg5YwpbIDUzODcuNzM0MjU3XSAgWzxmZmZmZmZmZjgxMDIyOTk3Pl0gPyBhY3Bp
X3N1c3BlbmRfbG93bGV2ZWwrMHgxYjcvMHgxZDAKWyA1Mzg3LjczNDI2Ml0gIFs8ZmZmZmZmZmY4
MTI4ZmIxMD5dIGFjcGlfc3VzcGVuZF9lbnRlcisweDM3LzB4OTYKWyA1Mzg3LjczNDI2Nl0gIFs8
ZmZmZmZmZmY4MTA4ZWM2MD5dIHN1c3BlbmRfZGV2aWNlc19hbmRfZW50ZXIrMHgxNWUvMHgyMTMK
WyA1Mzg3LjczNDI3MF0gIFs8ZmZmZmZmZmY4MTA4ZWRmYj5dIGVudGVyX3N0YXRlKzB4ZTYvMHgx
M2MKWyA1Mzg3LjczNDI3M10gIFs8ZmZmZmZmZmY4MTA4ZTNjYj5dIHN0YXRlX3N0b3JlKzB4YWUv
MHhjYgpbIDUzODcuNzM0Mjc3XSAgWzxmZmZmZmZmZjgxMTg2ZGQxPl0gPyBzeXNmc193cml0ZV9m
aWxlKzB4MTAwLzB4MTVkClsgNTM4Ny43MzQyODNdICBbPGZmZmZmZmZmODEyNDlkZGI+XSBrb2Jq
X2F0dHJfc3RvcmUrMHgxNy8weDE5ClsgNTM4Ny43MzQyODddICBbPGZmZmZmZmZmODExODZkZjI+
XSBzeXNmc193cml0ZV9maWxlKzB4MTIxLzB4MTVkClsgNTM4Ny43MzQyOTNdICBbPGZmZmZmZmZm
ODExMjVkZTQ+XSB2ZnNfd3JpdGUrMHhlNi8weDEzZApbIDUzODcuNzM0Mjk2XSAgWzxmZmZmZmZm
ZjgxMTI2MDJkPl0gc3lzX3dyaXRlKzB4NGEvMHg2ZQpbIDUzODcuNzM0MzAyXSAgWzxmZmZmZmZm
ZjgxNWU1YTAyPl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiCgo=
--20cf3040ee1caf682104b0e253db--
