Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1GAK0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 06:26:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:41472 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab1GAK0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 06:26:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,457,1304319600"; 
   d="scan'208";a="22702132"
From: "Ma, Ling" <ling.ma@intel.com>
To: "Ma, Ling" <ling.ma@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 1 Jul 2011 18:26:31 +0800
Subject: RE: [PATCH RFC] [x86] Optimize copy-page by reducing impact from HW
 prefetch
Thread-Topic: [PATCH RFC] [x86] Optimize copy-page by reducing impact from
 HW prefetch
Thread-Index: Acwxc9zXuTo3YQvYQpKzil1gi1OinwEGCmlAAI3KBfAAAzaU0A==
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F27124E99DE@shsmsx502.ccr.corp.intel.com>
References: <1308351117-32452-1-git-send-email-ling.ma@intel.com>
 <m2fwn13a3u.fsf@firstfloor.org> <20110623070448.GA25707@elte.hu>  
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_C10D3FB0CD45994C8A51FEC1227CE22F27124E99DEshsmsx502ccrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_C10D3FB0CD45994C8A51FEC1227CE22F27124E99DEshsmsx502ccrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Sorry for incorrect copy_page_c results from movsb not movsq.

Update results :
(the benchmark is not enough accurate, but it could tell us which is faster=
)

1. We copy 4096 bytes for 32 times on snb, and extract minimum execution ti=
me

On hot cache case:
   Copy_page          copy_page_c    copy_page_sse2 without preftch (128bit=
 write /cycle)   copy_page_sse2 with prefetch (128bit write /cycle)
   437 cycles          226 cycles    183                                   =
                 208
=20

2. the same routine with hot-caches, but before each execution we copy
 512k data to push original data out of L1 &L2.
 On cold cache case:

 copy_page(with prefetch)  copy_page(without prefetch)  copy_page_c  copy_p=
age_sse2 without preftch (128bit write /cycle)  copy_page_sse2 with prefetc=
h(128bit write /cycle)
  688~713                  847~860                      636~648      661~67=
3                                               609~615                    =
                    =20

Answer to the question from Ingo, copy_page_c is always faster to copy page=
,
but copy_page_c doesn't use prefetch for cold-cache cases, and append prefe=
tch according to copy size.

Thanks
Ling
 =20



> -----Original Message-----
> From: Ma, Ling
> Sent: Friday, July 01, 2011 4:11 PM
> To: Ma, Ling; 'Ingo Molnar'; 'Andi Kleen'
> Cc: 'hpa@zytor.com'; 'tglx@linutronix.de'; 'linux-
> kernel@vger.kernel.org'
> Subject: RE: [PATCH RFC] [x86] Optimize copy-page by reducing impact
> from HW prefetch
>=20
> Forget to append experiment data:
>=20
> 1. We copy 4096 bytes for 32 times on snb, and extract minimum
> execution time
> On hot cache case:
>   Copy_page          copy_page_c
>   482 cycles          350 cycles
>=20
> 2. the same routine with hot-caches, but before each execution we copy
> 512k data to push original data out of L1 &L2.
> On cold cache case:
>   copy_page(with prefetch)    copy_page(without prefetch)
> copy_page_c
>    853~873 cycles                  1037~1051 cycles            959~976
> cycles
>=20
> Thanks
> Ling
>=20
> > -----Original Message-----
> > From: Ma, Ling
> > Sent: Tuesday, June 28, 2011 11:24 PM
> > To: 'Ingo Molnar'; Andi Kleen
> > Cc: hpa@zytor.com; tglx@linutronix.de; linux-kernel@vger.kernel.org
> > Subject: RE: [PATCH RFC] [x86] Optimize copy-page by reducing impact
> > from HW prefetch
> >
> > Hi Ingo
> >
> > > Ling, mind double checking which one is the faster/better one on
> SNB,
> > > in cold-cache and hot-cache situations, copy_page or copy_page_c?
> > Copy_page_c
> > on hot-cache copy_page_c on SNB combines data to 128bit (processor
> > limit 128bit/cycle for write) after startup latency
> > so it is faster than copy_page which provides 64bit/cycle for write.
> >
> > on cold-cache copy_page_c doesn't use prefetch, which uses prfetch
> > according to copy size,
> > so copy_page function is better.
> >
> > Thanks
> > Ling


--_002_C10D3FB0CD45994C8A51FEC1227CE22F27124E99DEshsmsx502ccrc_
Content-Type: application/octet-stream; name="snb_info"
Content-Description: snb_info
Content-Disposition: attachment; filename="snb_info"; size=6888;
	creation-date="Thu, 02 Dec 2010 18:56:58 GMT";
	modification-date="Fri, 01 Jul 2011 18:23:47 GMT"
Content-Transfer-Encoding: base64

cHJvY2Vzc29yCTogMAp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9k
ZWwJCTogNDIKbW9kZWwgbmFtZQk6IEdlbnVpbmUgSW50ZWwoUikgQ1BVIDAgQCAyLjYwR0h6CnN0
ZXBwaW5nCTogMwpjcHUgTUh6CQk6IDE2MDAuMDAwCmNhY2hlIHNpemUJOiA4MTkyIEtCCnBoeXNp
Y2FsIGlkCTogMApzaWJsaW5ncwk6IDgKY29yZSBpZAkJOiAwCmNwdSBjb3Jlcwk6IDQKYXBpY2lk
CQk6IDAKaW5pdGlhbCBhcGljaWQJOiAwCmZwdQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpj
cHVpZCBsZXZlbAk6IDEzCndwCQk6IHllcwpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNy
IHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNo
IGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0IHRtIHBiZSBzeXNjYWxsIG54IHJkdHNj
cCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJmbW9uIHBlYnMgYnRzIHJlcF9nb29kIG5vcGwgeHRv
cG9sb2d5IG5vbnN0b3BfdHNjIGFwZXJmbXBlcmYgcG5pIHBjbG11bHFkcSBkdGVzNjQgbW9uaXRv
ciBkc19jcGwgdm14IHNteCBlc3QgdG0yIHNzc2UzIGN4MTYgeHRwciBwZGNtIHNzZTRfMSBzc2U0
XzIgeDJhcGljIHBvcGNudCBhZXMgeHNhdmUgYXZ4IGxhaGZfbG0gaWRhIGFyYXQgeHNhdmVvcHQg
cGxuIHB0cyBkdHMgdHByX3NoYWRvdyB2bm1pIGZsZXhwcmlvcml0eSBlcHQgdnBpZApib2dvbWlw
cwk6IDUxOTkuODkKY2xmbHVzaCBzaXplCTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVz
cyBzaXplcwk6IDM2IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2Vt
ZW50OgoKcHJvY2Vzc29yCTogMQp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6
IDYKbW9kZWwJCTogNDIKbW9kZWwgbmFtZQk6IEdlbnVpbmUgSW50ZWwoUikgQ1BVIDAgQCAyLjYw
R0h6CnN0ZXBwaW5nCTogMwpjcHUgTUh6CQk6IDE2MDAuMDAwCmNhY2hlIHNpemUJOiA4MTkyIEtC
CnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6IDgKY29yZSBpZAkJOiAxCmNwdSBjb3Jlcwk6IDQK
YXBpY2lkCQk6IDIKaW5pdGlhbCBhcGljaWQJOiAyCmZwdQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6
IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6IHllcwpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0
c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBj
bGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0IHRtIHBiZSBzeXNjYWxsIG54
IHJkdHNjcCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJmbW9uIHBlYnMgYnRzIHJlcF9nb29kIG5v
cGwgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGFwZXJmbXBlcmYgcG5pIHBjbG11bHFkcSBkdGVzNjQg
bW9uaXRvciBkc19jcGwgdm14IHNteCBlc3QgdG0yIHNzc2UzIGN4MTYgeHRwciBwZGNtIHNzZTRf
MSBzc2U0XzIgeDJhcGljIHBvcGNudCBhZXMgeHNhdmUgYXZ4IGxhaGZfbG0gaWRhIGFyYXQgeHNh
dmVvcHQgcGxuIHB0cyBkdHMgdHByX3NoYWRvdyB2bm1pIGZsZXhwcmlvcml0eSBlcHQgdnBpZApi
b2dvbWlwcwk6IDUyMDAuMDMKY2xmbHVzaCBzaXplCTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQK
YWRkcmVzcyBzaXplcwk6IDM2IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBt
YW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogMgp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZh
bWlseQk6IDYKbW9kZWwJCTogNDIKbW9kZWwgbmFtZQk6IEdlbnVpbmUgSW50ZWwoUikgQ1BVIDAg
QCAyLjYwR0h6CnN0ZXBwaW5nCTogMwpjcHUgTUh6CQk6IDE2MDAuMDAwCmNhY2hlIHNpemUJOiA4
MTkyIEtCCnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6IDgKY29yZSBpZAkJOiAyCmNwdSBjb3Jl
cwk6IDQKYXBpY2lkCQk6IDQKaW5pdGlhbCBhcGljaWQJOiA0CmZwdQkJOiB5ZXMKZnB1X2V4Y2Vw
dGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6IHllcwpmbGFncwkJOiBmcHUgdm1lIGRl
IHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBw
c2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0IHRtIHBiZSBzeXNj
YWxsIG54IHJkdHNjcCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJmbW9uIHBlYnMgYnRzIHJlcF9n
b29kIG5vcGwgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGFwZXJmbXBlcmYgcG5pIHBjbG11bHFkcSBk
dGVzNjQgbW9uaXRvciBkc19jcGwgdm14IHNteCBlc3QgdG0yIHNzc2UzIGN4MTYgeHRwciBwZGNt
IHNzZTRfMSBzc2U0XzIgeDJhcGljIHBvcGNudCBhZXMgeHNhdmUgYXZ4IGxhaGZfbG0gaWRhIGFy
YXQgeHNhdmVvcHQgcGxuIHB0cyBkdHMgdHByX3NoYWRvdyB2bm1pIGZsZXhwcmlvcml0eSBlcHQg
dnBpZApib2dvbWlwcwk6IDUyMDAuMDMKY2xmbHVzaCBzaXplCTogNjQKY2FjaGVfYWxpZ25tZW50
CTogNjQKYWRkcmVzcyBzaXplcwk6IDM2IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApw
b3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogMwp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwK
Y3B1IGZhbWlseQk6IDYKbW9kZWwJCTogNDIKbW9kZWwgbmFtZQk6IEdlbnVpbmUgSW50ZWwoUikg
Q1BVIDAgQCAyLjYwR0h6CnN0ZXBwaW5nCTogMwpjcHUgTUh6CQk6IDE2MDAuMDAwCmNhY2hlIHNp
emUJOiA4MTkyIEtCCnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6IDgKY29yZSBpZAkJOiAzCmNw
dSBjb3Jlcwk6IDQKYXBpY2lkCQk6IDYKaW5pdGlhbCBhcGljaWQJOiA2CmZwdQkJOiB5ZXMKZnB1
X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6IHllcwpmbGFncwkJOiBmcHUg
dm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1jYSBjbW92
IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0IHRtIHBi
ZSBzeXNjYWxsIG54IHJkdHNjcCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJmbW9uIHBlYnMgYnRz
IHJlcF9nb29kIG5vcGwgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGFwZXJmbXBlcmYgcG5pIHBjbG11
bHFkcSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IHNteCBlc3QgdG0yIHNzc2UzIGN4MTYgeHRw
ciBwZGNtIHNzZTRfMSBzc2U0XzIgeDJhcGljIHBvcGNudCBhZXMgeHNhdmUgYXZ4IGxhaGZfbG0g
aWRhIGFyYXQgeHNhdmVvcHQgcGxuIHB0cyBkdHMgdHByX3NoYWRvdyB2bm1pIGZsZXhwcmlvcml0
eSBlcHQgdnBpZApib2dvbWlwcwk6IDUyMDAuMDMKY2xmbHVzaCBzaXplCTogNjQKY2FjaGVfYWxp
Z25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM2IGJpdHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmly
dHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogNAp2ZW5kb3JfaWQJOiBHZW51aW5l
SW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogNDIKbW9kZWwgbmFtZQk6IEdlbnVpbmUgSW50
ZWwoUikgQ1BVIDAgQCAyLjYwR0h6CnN0ZXBwaW5nCTogMwpjcHUgTUh6CQk6IDE2MDAuMDAwCmNh
Y2hlIHNpemUJOiA4MTkyIEtCCnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6IDgKY29yZSBpZAkJ
OiAwCmNwdSBjb3Jlcwk6IDQKYXBpY2lkCQk6IDEKaW5pdGlhbCBhcGljaWQJOiAxCmZwdQkJOiB5
ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6IHllcwpmbGFncwkJ
OiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1j
YSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0
IHRtIHBiZSBzeXNjYWxsIG54IHJkdHNjcCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJmbW9uIHBl
YnMgYnRzIHJlcF9nb29kIG5vcGwgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGFwZXJmbXBlcmYgcG5p
IHBjbG11bHFkcSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IHNteCBlc3QgdG0yIHNzc2UzIGN4
MTYgeHRwciBwZGNtIHNzZTRfMSBzc2U0XzIgeDJhcGljIHBvcGNudCBhZXMgeHNhdmUgYXZ4IGxh
aGZfbG0gaWRhIGFyYXQgeHNhdmVvcHQgcGxuIHB0cyBkdHMgdHByX3NoYWRvdyB2bm1pIGZsZXhw
cmlvcml0eSBlcHQgdnBpZApib2dvbWlwcwk6IDUyMDAuMDMKY2xmbHVzaCBzaXplCTogNjQKY2Fj
aGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM2IGJpdHMgcGh5c2ljYWwsIDQ4IGJp
dHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogNQp2ZW5kb3JfaWQJOiBH
ZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogNDIKbW9kZWwgbmFtZQk6IEdlbnVp
bmUgSW50ZWwoUikgQ1BVIDAgQCAyLjYwR0h6CnN0ZXBwaW5nCTogMwpjcHUgTUh6CQk6IDE2MDAu
MDAwCmNhY2hlIHNpemUJOiA4MTkyIEtCCnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6IDgKY29y
ZSBpZAkJOiAxCmNwdSBjb3Jlcwk6IDQKYXBpY2lkCQk6IDMKaW5pdGlhbCBhcGljaWQJOiAzCmZw
dQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6IHllcwpm
bGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIg
cGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2Uy
IHNzIGh0IHRtIHBiZSBzeXNjYWxsIG54IHJkdHNjcCBsbSBjb25zdGFudF90c2MgYXJjaF9wZXJm
bW9uIHBlYnMgYnRzIHJlcF9nb29kIG5vcGwgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGFwZXJmbXBl
cmYgcG5pIHBjbG11bHFkcSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IHNteCBlc3QgdG0yIHNz
c2UzIGN4MTYgeHRwciBwZGNtIHNzZTRfMSBzc2U0XzIgeDJhcGljIHBvcGNudCBhZXMgeHNhdmUg
YXZ4IGxhaGZfbG0gaWRhIGFyYXQgeHNhdmVvcHQgcGxuIHB0cyBkdHMgdHByX3NoYWRvdyB2bm1p
IGZsZXhwcmlvcml0eSBlcHQgdnBpZApib2dvbWlwcwk6IDUyMDAuMDMKY2xmbHVzaCBzaXplCTog
NjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM2IGJpdHMgcGh5c2ljYWws
IDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogNgp2ZW5kb3Jf
aWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogNDIKbW9kZWwgbmFtZQk6
IEdlbnVpbmUgSW50ZWwoUikgQ1BVIDAgQCAyLjYwR0h6CnN0ZXBwaW5nCTogMwpjcHUgTUh6CQk6
IDE2MDAuMDAwCmNhY2hlIHNpemUJOiA4MTkyIEtCCnBoeXNpY2FsIGlkCTogMApzaWJsaW5ncwk6
IDgKY29yZSBpZAkJOiAyCmNwdSBjb3Jlcwk6IDQKYXBpY2lkCQk6IDUKaW5pdGlhbCBhcGljaWQJ
OiA1CmZwdQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEzCndwCQk6
IHllcwpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2Vw
IG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNz
ZSBzc2UyIHNzIGh0IHRtIHBiZSBzeXNjYWxsIG54IHJkdHNjcCBsbSBjb25zdGFudF90c2MgYXJj
aF9wZXJmbW9uIHBlYnMgYnRzIHJlcF9nb29kIG5vcGwgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGFw
ZXJmbXBlcmYgcG5pIHBjbG11bHFkcSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IHNteCBlc3Qg
dG0yIHNzc2UzIGN4MTYgeHRwciBwZGNtIHNzZTRfMSBzc2U0XzIgeDJhcGljIHBvcGNudCBhZXMg
eHNhdmUgYXZ4IGxhaGZfbG0gaWRhIGFyYXQgeHNhdmVvcHQgcGxuIHB0cyBkdHMgdHByX3NoYWRv
dyB2bm1pIGZsZXhwcmlvcml0eSBlcHQgdnBpZApib2dvbWlwcwk6IDUyMDAuMDMKY2xmbHVzaCBz
aXplCTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM2IGJpdHMgcGh5
c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoKcHJvY2Vzc29yCTogNwp2
ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9kZWwJCTogNDIKbW9kZWwg
bmFtZQk6IEdlbnVpbmUgSW50ZWwoUikgQ1BVIDAgQCAyLjYwR0h6CnN0ZXBwaW5nCTogMwpjcHUg
TUh6CQk6IDE2MDAuMDAwCmNhY2hlIHNpemUJOiA4MTkyIEtCCnBoeXNpY2FsIGlkCTogMApzaWJs
aW5ncwk6IDgKY29yZSBpZAkJOiAzCmNwdSBjb3Jlcwk6IDQKYXBpY2lkCQk6IDcKaW5pdGlhbCBh
cGljaWQJOiA3CmZwdQkJOiB5ZXMKZnB1X2V4Y2VwdGlvbgk6IHllcwpjcHVpZCBsZXZlbAk6IDEz
CndwCQk6IHllcwpmbGFncwkJOiBmcHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFw
aWMgc2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBm
eHNyIHNzZSBzc2UyIHNzIGh0IHRtIHBiZSBzeXNjYWxsIG54IHJkdHNjcCBsbSBjb25zdGFudF90
c2MgYXJjaF9wZXJmbW9uIHBlYnMgYnRzIHJlcF9nb29kIG5vcGwgeHRvcG9sb2d5IG5vbnN0b3Bf
dHNjIGFwZXJmbXBlcmYgcG5pIHBjbG11bHFkcSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IHNt
eCBlc3QgdG0yIHNzc2UzIGN4MTYgeHRwciBwZGNtIHNzZTRfMSBzc2U0XzIgeDJhcGljIHBvcGNu
dCBhZXMgeHNhdmUgYXZ4IGxhaGZfbG0gaWRhIGFyYXQgeHNhdmVvcHQgcGxuIHB0cyBkdHMgdHBy
X3NoYWRvdyB2bm1pIGZsZXhwcmlvcml0eSBlcHQgdnBpZApib2dvbWlwcwk6IDUyMDAuMDMKY2xm
bHVzaCBzaXplCTogNjQKY2FjaGVfYWxpZ25tZW50CTogNjQKYWRkcmVzcyBzaXplcwk6IDM2IGJp
dHMgcGh5c2ljYWwsIDQ4IGJpdHMgdmlydHVhbApwb3dlciBtYW5hZ2VtZW50OgoK

--_002_C10D3FB0CD45994C8A51FEC1227CE22F27124E99DEshsmsx502ccrc_--
