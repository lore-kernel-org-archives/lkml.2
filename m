Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1L1S4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 13:56:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41378 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1L1Sz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 13:55:59 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Possible bug introduced in commit 9b84cca
Date: Wed, 28 Dec 2011 19:55:55 +0100
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?=C5=81ukasz_Michalik?= <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7Y2+OSoHiqyIXcV"
Message-Id: <201112281955.55200.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_7Y2+OSoHiqyIXcV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Tejun, Oleg,

Apologies if you are already informed about this bug
by people who originally discovered it.

Looks like after commit 9b84cca, waitpid under strace
sometimes returns bogus ECHILD while child does exist.

I did not yet confirm that the bug appeared exactly
at this commit - =C5=81ukasz says that.

I confirmed that bug exists on kernels 3.1.6 (in Fedora)
and 3.1.0-rc4 (vanilla).

We have a testcase which spawns N threads, each of them
performs an infinite loop "fork, exit in child, waitpid
in parent for the child". When straced, sometimes waitpid
returns ECHILD. In fact, there is no need to run many threads -
I just saw it happening with single thread on 4-CPU machine
when I ran "strace -otestcase1.LOG -f ./testcase1 1".
This machine uses 3.1.0-rc4.

Please find testcase attached.

Also please find testcase1.LOG attached.
The key part is here:

931   clone(child_stack=3D0, flags=3DCLONE_CHILD_CLEARTID|CLONE_CHILD_SETTI=
D|SIGCHLD, child_tidptr=3D0xf763dbd8) =3D 1048
1048  exit_group(42)                    =3D ?
931   waitpid(1048,  <unfinished ...>
1048  +++ exited with 42 +++
931   <... waitpid resumed> 0xf763d3a0, 0) =3D -1 ECHILD (No child processe=
s)

To complicate matters, this is observed only under development
version of strace. Old (released) versions of strace do not
let ptraced processes to die - they detach from them when
they think they are going to die (such as when they enter _exit()
or receive a "deadly" signal). Which is a aesthetically horrible and
logically buggy (racy) hack, so we are removing it from strace.
=C5=81ukasz says that old strace versions (ones which still use the hack)
don't trigger the bug.

=46or testing, I will send you strace source tree and pre-compiled
strace binary in a separate email. Alternatively, pull latest
strace git and "autoreconf -fvi && ./configure && make" it.

=2D-=20
vda

--Boundary-00=_7Y2+OSoHiqyIXcV
Content-Type: text/x-csrc;
  charset="utf-8";
  name="testcase1.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="testcase1.c"

#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/sysinfo.h>
#include <sys/wait.h>
#include <stdio.h>
#include <pthread.h>

void* worker(void *arg)
{
	while (1) {
		pid_t p = fork();
		if (-1 == p) { /* error */
			perror("fork");
			_exit(EXIT_FAILURE);
		}
		if (0 == p) { /* child */
			_exit(42);
		}
		/* parent */
		int stat_loc;
		int s = waitpid(p, &stat_loc, 0);
		if (-1 == s) {
			perror("waitpid");
			_exit(EXIT_FAILURE);
		}
	}
}

int main(int argc, char **argv)
{
	int pool_size = get_nprocs() * 4;

	if (argv[1])
		pool_size = atoi(argv[1]);
	printf("Poolsize: %d\n", pool_size);

	pthread_t thread_id;
	int i;
	for (i = 0; i != pool_size; ++i) {
		if (pthread_create(&thread_id, NULL, worker, NULL) != 0) {
			perror("pthread_create");
			_exit(EXIT_FAILURE);
		}
	}

	/* Prevent exiting: wait for last thread (forever) */
	void *retval;
	pthread_join(thread_id, &retval);

	return 43;
}

--Boundary-00=_7Y2+OSoHiqyIXcV
Content-Type: application/x-bzip2;
  name="testcase1.LOG.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="testcase1.LOG.bz2"

QlpoOTFBWSZTWddTbrsAIJr/gGs4YUBRf//3v+/f7r/v3/5gElzBEGvfSqnXg8ZHs9BfBvFXyMKV
7a8AvgKqKJVIkqCkSRIZSZJ7TJKAAGgAABoAAAABoADSEfqe1STURqGSbRkAmhkMnqaMAAAhkwAE
qkp//6qSoNqAAAAAAAAAAAAAA0/VSSmn+lTeij1NDQNANAAAAAAAAAApUQkyBPUyaJ6Kempkaeo2
SAGnkIaaaek9TQ02pkAIlBAQAgTRMk2poDR5Q2nqI9QAPU9IaaY1DTXrPU2dkCbFrAAAAAAAAATY
tYAnF3uvepqMWZhwpte9sqWLKs2rerVWS/fe/Hg8vzOrzQAAAAAAAAA6ZznOc51rQAASSSSQAAA6
wJJJrOdSSSAAAdfCSpVx1pKla1KkrWVKt9sa5uubW526ueedcgHUAAAAABoAN1ptt61rQABJJJJA
NAAc5nEkk4znV73ve+rjjjjjjjjlnxysAAAAAAAAATbWsADK2WFgAAAAAAADcVVVSqs0lVVtus55
55555gAAEkkkkAAAJJnOc5M5JJJAAAJSVKi1JUq1a6VqSpValZWtrV7a1rWtEAACSSSSASSSTJnO
c5znMkkkAAAhayVWsqVrKlayVqSpVa3FbYxrWta1NAAAAAAAAAApAIIsuBBBxgAQaqHOJIJnOc2Z
mqRESqUpAAAAASSTYvpVSpV0VdElSr9qSpV6fp+j0dPW9ndaRLmpLliWIl57nrb1UlkaoO6gotAh
JnRT2lSiqE6qUtCnxSkmJ5uXI5IlqJZ72WXNhMsMIGyI+j9jIHTVjFjALGFStaS3PuTEE1gcYAfN
A+IBGJvBQkUdCh/qjhlJZqlh7MlL3aS7Ilnq2SWU9MaBBCQPbS5VoV9313ARtd+mgY1CgiDmzl7m
olpEt1JYanliWJ4/9fYfDu8u7THfY83t8B3eSPjlJ3AIwBHZu74/U79pLTdJIfYUmPwcQE9xayVZ
ndLII2QA1EQUADgjCL0BBBdmgAg5gAIPtCr7bvlO807+rOwKyCPb5UqVv+H6N4CO5BHD2b/p9HD0
p2MoQxeMmhKzARAAAAAAAAAEQASzKenCYZgAAAAAAAAAAAAAAAAAAAABnklStM82nU50lVKlWlVK
lZ328Tv+Hnu9P8gAAAAAAAAAm222AAAEkkkkAAAJJnOc5M5JJJAAAPiIl3O+qv4ZM45idrWtau6k
qVXrFcKz717+PSoFQ8PiK1ClCh8hsM+/JO4gbTb3m0N3XDjNYE67FL4m+lOnv3vgbgE1iAGwsgjp
A0tQr2LdbKkqVTuvY7cnV1gAAAAAAAAADbbbAAACSSSSAAAEkznOcmckkkgAARUqVZpKlVlundeE
fXfSX9kqSl4US/VintJS/ikuq0hWkKy/OUURh8HnhUfR4YFyH1Epc4pnJCECMhIJtpQm7pbn18+z
HLsjTPPPPPPPO8ve97qWte97igREe973yWyK1gQJAJojGM5s2jXrKpAlaWCAQbajtC+7DLdu3bs9
UEczQgAYEdNu7PZ9fk6sMKUxvGsxwtc4ZWrhhunMqA6kFYMQTfFCgxFYMFGJjKLC5BoYUH7WxQaE
TlvplB5AaIBzHpGQ6dIIjUkrWhQhJPtJQkkkhLII47uOzTht28L5ZZVyyyxyve97XuqqFKaaaaSS
QURHve97CvJxvqoBEREZpzWZMRagMzY06dOnT+tfqWTYXosbNISEhISEhISEhISEhISEhISEhISE
hISEm+xixYJCQkJCQkJCQkJCQkJBVrvLGI11K1CfJUre1IWoOBBrhRQ6GNA0nXbt2VdxJ0lOronT
t2RdnHZ2dOQAABpttttttgGMYx2tUlSrur10qeKSpV2XLKxcE+eeeRXtEWBAQN6SpUUpbZWSrwaW
+KWbJLVhLQDGcY3pQrBuYAIytgthWxfXXLTXTTTTWtAabeG3httsCYxjC6UttttkGta1pKcVSE11
tqa666666BNCCDG0tKyKojGE71ilDW1phMJE0LAUoBSha1ilNEta9WsUoBShe9pV5NvqypKrSAxM
+HA4cMNmuOOJjjjjje973ve973vllllSlK3wGl73MssMcspjTKmRlllllaDuAgXg0QR4II0OiCOl
gEag5QaQcIOsCMkhe1R27L0t79FxDtc6AEAA2222222AYxjGMYwgALoAQGQ2W1GFXCUuqSxi6rKs
lUx0sLZU7KrccCnHHAACAAbbbbbbbAMYxjv7433vuta1rQ1apZIubIACqFe6pLFUiwPV+mBQvBsw
TOQmcGpBljjzKldu3JTnnPPAAgAG222222wDGMYztttsgYGEAIGAq8FpveqTs+l1VsVelZW4VlXS
qoW4FBzqobCWbBWFBgwDXC2mwtnrjpniFxAANtttttt7gGMYxtnbbtV2JKleyoACMHxi5zNJmkof
Q5UfQqiCqqKrgYCAvQJ3LhcbEHZWgbYBqQdINImu2m2DamZjnha+OzEAAABttttttsC973vcAAQA
BnnmNNKDStAzJCLbuEGRVEYEOrbUrCQkJCQkJGMrU0Z2dnmkJCQkJCQkJCRiyxYsYSEhISEhISEj
FbDRoyy0Z2dnmkJCQkJCQkJCRiyxYsYSEhISEhISEjFlixYwkJCQkJCQkJGLLFixhISEhISEhISV
qVK148PX8h+g6ypChClzMRR9kJFhA/jD58aer1v560p6sLTpEsvoxQNpHrwQ9fc6PliWIljuUlmJ
dQmGsSxppA3iWkS1SXk/LEtJ8z3qS5LzYqLfSXpegPtfV56+sr/OyS3PtLAl818epyUS9iJex9f2
Y8cS2pL4sxLAVjPliXz8BLcZiX2YiWkS2PpmhVGqS259xmmkS469xXIDERH3PVZARoHG7p+Yrhwv
/IKlDPngojhvdYliJeAS6HTSlinFJa6YNMlWupoSogjWJ6Zvdn9RQRzhARHA0CWLoFLtJLo53a24
Ne92OqXZFR1b6g4B19ODx2l4py3iCMERugjEEYIjLmR7kfdcFR6bQ/f3q9oMsaf5WeTZQ16cQVGo
QLdlloaHMYwutQpWct0xpRRl4jNdVLsrjvnY39HbktmwYjpK6/D3dyHZFNHDjXBHuB5eSijgIj/T
x0m6k1O3aKjU3zt2qI1QR1QRo7HdQh3AI5yt04duGvZ1HUCjDhAVGxRS+fZrEEYIjG4SxrSWwlpo
7UcNMx066y3+HgJbq6G8tufDqEvnEvF1Gsdy5DFKhxdq5kCmzRFHwflh2+YqVEkJA9ZIR94+XVow
6mZnzf3/oJafdb+h/t7tddEvAku36bBgWQRvUJu60+7h5L4A5pZXyzNBG5Uvro7+PK0j4Hvv+RL/
uX7apePTM637n0vY3xLaMRLBvSWUS4NGiSxpEq+XzFD0bPUaZCI7D48V+8+75z4VEfsEEeZlyoLj
h4a7D5zCqqM5nserkVoijSWPafi+gwwej6zXUrrj1HruVd2B/6uh6hEYIjQRGKo2/x3olo8/MbmN
cFLtpLiJZpLXImLEDKSzo9u4ylsktklja2ERuqjR0VRueM0tioj1tcs/H28vSk7xEfF/fHh5YQxO
4q/bsN2YgjVoKjgdxyoRe90mc8aS0klvSX8G5cvY3+Q1Z9De7rX3yXNshLkERqnxl94Xe87VVQ59
Z1HRGGrwUl7eUV1HhY8TTRJcqS0pLmpLu8cYpL0xLKktGilR3zv0qNCloUu2qo8mzVEsTg0pL4dX
e40luvF2sOtJYdrJJe9SXdRLpNbvZx3Ulrc/DppLrpLwsSS0baho9Qcn5Zs2Ko4+/yNT9RQ5g4Ze
c44iCNCSxOctZhfU5zmbN2Uliks0lll5Ilu5G62cMmjk83xXfOmJceqs8IlxTXMwER0Lno2p2XTM
0FR8XM5KIwHQy2BmII1QR/BDsudOAduqiPDTqqTVRHbDU26vkIc/etDOyiPjNr566aOIHARHO7N2
Dr28Dj7gS2ZfB1RLcktN84Gr2uabOVme/10llEuMSxSo4lLkxcPaOAYujkmSYiI37fMlUEakQRqW
qIjfZp20I6VTxFABbAbyGL0aNC9BFGhDZsYpLbES2czotKS7NJS0iXJEuVuxuRLdSWrhscsS110Y
SXP7KS8To8OIlzeCJbnbddxiXN0m3JvzBHriKNuMPxrxhRiKBBVQ59hDl0DI+YBHvoALPUfnfjER
8PCSUPVCDCBT11Z5cRLjEvcPjxtj0tPhEv/i7kinChIa6m3XYA==

--Boundary-00=_7Y2+OSoHiqyIXcV--
