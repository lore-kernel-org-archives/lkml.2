Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1AGPPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:15:13 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:25083 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751389Ab1AGPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:15:11 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: SNaOG1AVM1kitLeFGHHPDaUuKvCKhkYwWXZP4DoKfYJBoC4
 ODdkMuRHWmcNQUIcYOD0zeR8GqSKt6pxxJnsNn.5cWax2pzJi1aY9NFRrsdO
 VGzzU9v0yUx9hJusG9a.b.61DsBcTstEnE2VIxSjLZM0y5NwuRP3kh6g3heQ
 xXCISJsQKlD7jVonRq7vLuSUMXbUEe1xLDLKjn4ERJMgiWfOJBhhXWHDCrPU
 b18taBko3bagxiY6b5Pwjd2y750coKqV_CSxxUAqOGAlfoEwwY6gf52lU54f
 cRqjDKNHJeAOCDCIRZdo3Er__xdiH0Zz8gw6yfVsTHUyduXo-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 7 Jan 2011 09:15:05 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <4D263C91.30709@zytor.com>
Message-ID: <alpine.DEB.2.00.1101070907060.3014@router.home>
References: <20110106204513.669098445@linux.com> <20110106204525.222395863@linux.com> <4D263C91.30709@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, H. Peter Anvin wrote:

> On 01/06/2011 12:45 PM, Christoph Lameter wrote:
> > Introduce this_cpu_cmpxchg_double. this_cpu_cmpxchg_double() allows the
> > comparision between two consecutive words and replaces them if there is
> > a match.
> >
> > 	bool this_cpu_cmpxchg_double(pcp1, pcp2,
> > 		old_word1, old_word2, new_word1, new_word2)
> >
> > this_cpu_cmpxchg_double does not return the old value (difficult since
> > there are two words) but a boolean indicating if the operation was
> > successful.
> >
> > The first percpu variable must be double word aligned!
>
> I really truly hate this interface.  The whole notion of passing two
> pointers where only one is really used, is just painful.

Well the second cpu variable is just there for correctness checking. That
way we can verify that the types are compatible for the second word and
that the second word was properly placed relative to the first one. It
also helps the reader in the source because it shows explicitly which two
words are modified by the operation.

If you look at the prior patch series at the use case you will see that
s->cpu_slab->tid was not referred to in the cmpxchg operation but
implicitly modified. That is bad and was the initial motivation to require
both to be specified.

During debugging I had a couple of problems with the way the compiler
placed those two fields that only became evident after painful debugging
sessions. With the checks possible only because both are specifiec there
is an explicit failure if either of the two cpu variables is specified in
such a way that the cmpxchg32b cannot work.


