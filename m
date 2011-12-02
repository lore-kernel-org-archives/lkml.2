Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab1LBQk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:40:57 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:52935 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab1LBQkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:40:55 -0500
Message-ID: <4ED8FF7C.2090509@linux.vnet.ibm.com>
Date: Fri, 02 Dec 2011 22:10:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Borislav Petkov <bp@amd64.org>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: fix error paths in microcode_init()
References: <4ED8E2270200007800065120@nat28.tlf.novell.com> <20111202143517.GA16690@gere.osrc.amd.com> <4ED8F46E0200007800065178@nat28.tlf.novell.com> <4ED8EB7D.5070802@linux.vnet.ibm.com> <20111202152403.GB16690@gere.osrc.amd.com> <4ED8FDE102000078000651E5@nat28.tlf.novell.com>
In-Reply-To: <4ED8FDE102000078000651E5@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120206-9264-0000-0000-000000520BC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 09:03 PM, Jan Beulich wrote:

>>>> On 02.12.11 at 16:24, Borislav Petkov <bp@amd64.org> wrote:
>> On Fri, Dec 02, 2011 at 08:45:09PM +0530, Srivatsa S. Bhat wrote:
>>> Your patch fixes the issue more properly than mine, but adding your part
>>> on top of my patch makes the code look better. For example,
>>> platform_device_unregister() wouldn't need to be called twice; and we 
>>> can use the quite popular way of handling error path via goto statements,
>>> which makes the code flow much more comprehensible and intuitive.
>>
>> Yes,
>>
>> goto labels is the proper way for spelling error handling in the kernel
>> so I could very well take your patch Jan, instead, if you change it to
>> use goto labels for the error path as Srivatsa's patch does it. That is,
>> in case Ingo hasn't pulled yet.
> 
> Sorry, no, I won't introduce new labels in functions not already using
> some (I'm already feeling guilty enough each time I end up doing so
> when a function already is coded that way, to limit the impact of a
> particular change). This is just bad programming style in my opinion, no
> matter what other developers may think on this subject.
> 


Hi Jan,
Honestly no offense meant, but I like using goto for error handling in
functions, especially when it results in clear-cut code flows such as:

do step1
do step2
...
undo step2
undo step1

It just makes it look so obvious and very easy to spot errors. However if
you have an if-else for everything and duplicate the undo code, chances are
that we might miss something/mess up the ordering. But in the flow shown
above, if you get the ordering right for once (which is quite easy), you
can just forget about it later on.

[I wouldn't have insisted if usage of goto statements would have messed up
code readability by not having a neat clear-cut sequence like that shown above.
But in the microcode driver case, since we are lucky to get this sequence,
I prefer to go by that.]

So, Boris, here is a patch which applies on top of my previous patch.
It is up to you to pull whichever patch you like (either mine or Jan's),
since it is only a choice of programming style, but functionality-wise,
the two are equivalent.

Thanks to Jan for pointing out the missing locking around
sysdev_driver_unregister() and that we can add __exit qualifier to
microcode_dev_exit().

And if Boris is indeed going to take this patch, Jan, feel free to add
your "Signed-off-by" (if you agree to the code below) since I would like
to give due credit to you for pointing out the missing parts.

---
[PATCH] x86 Microcode: Fix the microcode module initialization error path and improve code

The function sysdev_driver_unregister() must be called with proper locking
around it. So add this synchronization to the call to sysdev_driver_unregister()
in the microcode module initialization error path.

Also, add the __exit qualifier to microcode_dev_exit(), since it is called only
from microcode_exit().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/microcode_core.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index c7bdbfa..9d46f5e 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -256,7 +256,7 @@ static int __init microcode_dev_init(void)
 	return 0;
 }
 
-static void microcode_dev_exit(void)
+static void __exit microcode_dev_exit(void)
 {
 	misc_deregister(&microcode_dev);
 }
@@ -546,7 +546,14 @@ static int __init microcode_init(void)
 	return 0;
 
 out_sysdev_driver:
+	get_online_cpus();
+	mutex_lock(&microcode_mutex);
+
 	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+
+	mutex_unlock(&microcode_mutex);
+	put_online_cpus();
+
 out_pdev:
 	platform_device_unregister(microcode_pdev);
 	return error;




