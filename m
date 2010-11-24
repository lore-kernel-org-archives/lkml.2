Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0KXQRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:17:13 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:46681 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752748Ab0KXQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:17:12 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: oZ_EV10VM1kZkd1s8SbTIrwL8pPzCHYL9LOfQ3S84Hk029U
 64pFlloiPlWawam88KDsKlx5aM3IDdkNUN8oF.awi.GVImroL83rz4OnmDAO
 yMUKra0z5goHxy0QVpjaeV.PMlkKRgCjLDRFdOnpJQVSX0XkqOHvfAx0FBzI
 4bxBD5zfFzPdrWXXaaKhQouKZEIR.0wTgjEqVRN8_NpAIfy6bSejiQxAm3_0
 jt6xqJk0S_uo-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 24 Nov 2010 10:17:08 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
In-Reply-To: <AANLkTikVFWYS9UeCP1DJxhzYn9_rMcrovSfbQpNmXsvk@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011241012180.14268@router.home>
References: <20101123235139.908255844@linux.com> <20101123235201.758191189@linux.com> <AANLkTikVFWYS9UeCP1DJxhzYn9_rMcrovSfbQpNmXsvk@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1745053467-1290615190=:14268"
Content-ID: <alpine.DEB.2.00.1011241015070.14268@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1745053467-1290615190=:14268
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1011241015071.14268@router.home>

On Wed, 24 Nov 2010, Pekka Enberg wrote:

> > + =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0* The transaction ids are globally unique per cpu and =
per operation on
> > + =A0 =A0 =A0 =A0* a per cpu queue. Thus they can be guarantee that the=
 cmpxchg_double
> > + =A0 =A0 =A0 =A0* occurs on the right processor and that there was no =
operation on the
> > + =A0 =A0 =A0 =A0* linked list in between.
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 tid =3D c->tid;
> > + =A0 =A0 =A0 barrier();
>
> You're using a compiler barrier after every load from c->tid. Why?

To make sure that the compiler does not do something like loading the tid
later. The tid must be obtained before the rest of the information from
the per cpu slab data is retrieved in order to ensure that we have a
consistent set of data to operate on.

The critical section begins with the retrieval of the tid and it ends with
the replacement of the tid with the newly generated one. This means that
all state data for the alloc and free operation needs to be retrieved in
that critical section. The change must be saved with the final
cmpxchg_double of the critical section.

---1463811839-1745053467-1290615190=:14268--
