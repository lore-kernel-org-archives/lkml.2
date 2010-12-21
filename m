Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0LUWna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:43:30 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:46493 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753522Ab0LUWn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:43:29 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: lYrJlgUVM1mn8tTBGuGZOElHCcJNOJSnSGMUcY1ywbP11T_
 lYj0xsIDqnOq8VL8cLgfMezpE3J0AYf2y4aMViUU8thdZS7KftECw8x1tIJi
 RrCw1WPtyPi741FsivZdD.o9TE_pX60K0TnhWn.WmmataQZT0ZT_m0GMWzMI
 mMEL0MQhfwpbjbyw_rC6ebkuDGkrwiptX4V07EyVlcVknB6E7FodLd5Jg_9X
 s2bPze1QlOBylCkxyd0SKjDry2RHHLE0m.2qDH943KKQRZwbT5Cga74WVsWf
 F2kaIk5nZD99OmyLrr1KLW1YC2ReReHHtBTuMuClFyocH6G8-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 21 Dec 2010 16:43:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <htejun@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        rui.zhang@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: acpi throttling: Use this_cpu_has and simplify code
In-Reply-To: <4D0CD840.2050100@gmail.com>
Message-ID: <alpine.DEB.2.00.1012211638470.3769@router.home>
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home>
 <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com> <alpine.DEB.2.00.1012161215200.21588@router.home>
 <4D0CD840.2050100@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010, Tejun Heo wrote:

> It's bothersome that these methods don't have any indication that
> they're bound to local CPU when they can't be called with @pr for
> another CPU as MSRs can only be accessed from local CPU.

Right.

> In the longer run, it would be nice if there's an indication that this
> is only for the local CPU and maybe a WARN_ON_ONCE().  Maybe dropping
> @pr and using this_cpu_*() is better for performance too?

That is precisely the difficulty with many other functions that take
pointers to cpu_info. If we can establish that they are called *only* with
pointers to the current cpu then we can improve the function by dropping
the parameter and using this_cpu ops to access the cpu_info fields.

Using this_cpu ops instead of access to a field of a struct pointed to by
an array avoids an addition of pointers and replacest with a operation
that essentially takes a global address with a segment prefix. It reduces
register pressure and avoids the additions of pointers but it will encode
the address in the instruction.

