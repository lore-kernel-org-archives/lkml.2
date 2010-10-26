Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab0JZOGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:06:17 -0400
Received: from canuck.infradead.org ([134.117.69.58]:47757 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0JZOGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:06:16 -0400
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1288097074.15336.211.camel@twins>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
	 <1287788622-25860-1-git-send-email-venki@google.com>
	 <1288001573.15336.52.camel@twins>  <1288097074.15336.211.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Oct 2010 16:05:58 +0200
Message-ID: <1288101958.15336.284.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 14:44 +0200, Peter Zijlstra wrote:
> a smarter patch will try and avoid that loop. 

 a1 = a0 * e + a * (1 - e)

 a2 = a1 * e + a * (1 - e)
    = (a0 * e + a * (1 - e)) * e + a * (1 - e)
    = a0 * e^2 + a * (1 - e) * (1 + e)

 a3 = a2 * e + a * (1 - e)
    = (a0 * e^2 + a * (1 - e) * (1 + e)) * e + a * (1 - e)
    = a0 * e^3 + a * (1 - e) * (1 + e + e^2)

 an = a0 * e^n + a * (1 - e) * (1 + e + ... + e^n-1)
    = a0 * e^n + a * (1 - e) * (1 - e^n)/(1 - e)
    = a0 * e^n + a * (1 - e^n)


the trouble seems to be that that is a rather slow function, stuffing
that in a table will either give us very large tables or very coarse
decay.

   n: an         an * 2048

   1: 0.99446    2037
   2: 0.98895    2025
   4: 0.978023   2003
   8: 0.956529   1959
  16: 0.914947   1874
  32: 0.837128   1714
  64: 0.700784   1435
 128: 0.491098   1006
 256: 0.241177    494
 512: 0.0581666   119
1024: 0.00338335    7
2048: 1.14471e-05   0



