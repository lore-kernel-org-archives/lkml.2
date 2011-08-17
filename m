Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1HQU63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:58:29 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:49233 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1HQU61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:58:27 -0400
Message-ID: <4E4C2B6F.7000800@nod.at>
Date: Wed, 17 Aug 2011 22:58:23 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: user-mode-linux-devel@lists.sourceforge.net, gunnarlindroth@hotmail.com
Subject: Floating point problems on UML - help needed
Content-Type: multipart/mixed;
 boundary="------------010707040909000705010105"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010707040909000705010105
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Gunnar reported that some Java program does not work proper within 
UserModeLinux.
After looking closer at the problem I was able to reduce it to a small C 
program. (Program is attached.)

It looks like FPU registers get sometimes lost after switching between 
two or more threads.
It also happens not always, that's why my test program contains a 
infinite loop. After a few million iterations the program abort()s.

I can reproduce the issue on both x86 and x86_64, the host's or UML's 
kernel version does not matter.
I've tested 2.6.18 to 3.1-rc2.

Interestingly the problem occurs not on my old Pentium 4 machines.
One P4 has HT the other not.
Only "newer" CPUs are affected.

First I thought it's a race in _switch_to(), but adding 
unblock/block_signals() did not help.
Currently I'm running out of ideas.
I'm not an expert in this area of UML. :-(

Any idea what goes wrong here?

Thanks,
//richard

--------------010707040909000705010105
Content-Type: text/x-csrc;
 name="fpu-test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fpu-test.c"

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

static int xxx(float f)
{
	if(f <= 0.0){
		printf("wrong f!: %f\n", f);
		return -1;
	}

	return 0;
}

static void *fun(void *arg)
{
	float f = 5.0;

	for(;;){
		if(xxx(f) < 0)
			abort();
	}

	return NULL;
}

int main()
{
	pthread_t t1, t2;

	pthread_create(&t1, NULL, fun, NULL);
	pthread_create(&t2, NULL, fun, NULL);

	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	return 0;
}

--------------010707040909000705010105--
