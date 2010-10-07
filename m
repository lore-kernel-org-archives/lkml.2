Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0JGJv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 05:51:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab0JGJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 05:51:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=E4j6lOKsc8XGpaXU77nfC9GJ3MGrTy496pnd5/03ppGf9a0RLmT0gxMJJTkSJlm6C/
         kfJmqAU6rL16Im3P6Y/+1XVldaO9EJPCP3tNLU2jGaiQDiLgaXYK6YcgkbTQrT/pMbGU
         N1O//I4VRse4ym7ZIBzSWocGIykL8MBpc4nLI=
Subject: Re: [PATCH] sysctl: fix min/max handling in
 __do_proc_doulongvec_minmax()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Patrick McHardy <kaber@trash.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, ebiederm@xmission.com
In-Reply-To: <20101007092538.GE5471@cr0.nay.redhat.com>
References: <1286025469.2582.1806.camel@edumazet-laptop>
	 <20101004085913.GR14068@sgi.com>
	 <1286183058.18293.26.camel@edumazet-laptop>
	 <20101004093439.GG5189@cr0.nay.redhat.com>
	 <1286187030.18293.33.camel@edumazet-laptop>
	 <20101004103545.GJ5189@cr0.nay.redhat.com>
	 <1286188701.18293.57.camel@edumazet-laptop>
	 <20101005130117.GK5170@cr0.nay.redhat.com>
	 <20101007071859.GD5471@cr0.nay.redhat.com>
	 <20101007092538.GE5471@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 11:51:21 +0200
Message-ID: <1286445081.2912.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 07 octobre 2010 à 17:25 +0800, Américo Wang a écrit :
> >>
> >
> >Here is the final one.
> 
> Oops, that one is not correct. Hopefully this one
> is correct.
> 
> --------------->
> 
> Eric D. noticed that we may trigger an OOPS if we leave ->extra{1,2}
> to NULL when we use proc_doulongvec_minmax().
> 
> Actually, we don't need to store min/max values in a vector,
> because all the elements in the vector should share the same min/max
> value, like what proc_dointvec_minmax() does.
> 

If we assert same min/max limits are to be applied to all elements,
a much simpler fix than yours would be :

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f88552c..8e45451 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2485,7 +2485,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 		kbuf[left] = 0;
 	}
 
-	for (; left && vleft--; i++, min++, max++, first=0) {
+	for (; left && vleft--; i++, first=0) {
 		unsigned long val;
 
 		if (write) {


Please dont send huge patches like this to 'fix' a bug,
especially on slow path.

First we fix the bug, _then_ we can try to make code more 
efficient or more pretty or shorter.

So the _real_ question is :

Should the min/max limits should be a single pair,
shared by all elements, or a vector of limits.


