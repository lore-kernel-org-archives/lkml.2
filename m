Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1DQSHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:07:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49290 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1DQSHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:07:24 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=wom5GMh1gUkA:10 a=n9MmX0RCC_8A:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=isJYg_9NOmvcMoE_sM8A:9 a=zRh9av5Dop7F9ceQnpEA:7 a=CjuIK1q_8ugA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Sun, 17 Apr 2011 13:07:22 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: crocket <crockabiscuit@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
Message-ID: <20110417180722.GA21112@hallyn.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You need

	prctl(PR_SET_KEEPCAPS, 1);

man prctl for details.  In particular, see the following example:

#include <stdio.h>
#include <sys/prctl.h>
#include <sys/capability.h>

int main()
{
	cap_t c;
	c = cap_get_proc();
	printf("uid %d, current caps: %s\n", getuid(), cap_to_text(c, NULL));
	cap_free(c);
	prctl(PR_SET_KEEPCAPS, 1);
	setuid(1001, 1001, 1001);
	c = cap_get_proc();
	printf("uid %d, current caps: %s\n", getuid(), cap_to_text(c, NULL));
	cap_free(c);
}

You can either run that as root, or you can do

	sudo setcap cap_setuid,cap_setgid,cap_sys_admin=eip captest

and then run it as non-root.

HTH,
-serge
