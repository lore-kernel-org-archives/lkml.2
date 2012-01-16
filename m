Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2APC1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 21:27:14 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:50474 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab2APC1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 21:27:12 -0500
Message-ID: <4F138AFB.8040601@linux.vnet.ibm.com>
Date: Sun, 15 Jan 2012 21:27:07 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [Regression] Commit "tpm: Introduce function to poll for result
 of self test" breaks suspend
References: <201201160022.07176.rjw@sisk.pl>
In-Reply-To: <201201160022.07176.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12011602-4242-0000-0000-00000081818B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2012 06:22 PM, Rafael J. Wysocki wrote:
> Hi Stefan,
>
Hi Rafael,
> Unfortunately, the following commit from you:
>
> commit 68d6e6713fcb2ea6278661aaaf5f1c9c821b3751
> Author: Stefan Berger<stefanb@linux.vnet.ibm.com>
> Date:   Fri Nov 11 12:57:04 2011 -0500
>
>      tpm: Introduce function to poll for result of self test
>
>      This patch introduces a function that runs the TPM_ContinueSelfTest()
>      function and then polls the TPM to check whether it finished the selftest
>      and can receive new commands.
>
>      Signed-off-by: Stefan Berger<stefanb@linux.vnet.ibm.com>
>
> broke suspend on my Toshiba Portege R500.  It causes the tpm driver to
> return an error code from .suspend() on every attempt to suspend the system.
>

Can you show what the error output is?
Strange enough this function is not called during a suspend but during 
boot and again during resume. Can you try the following after a boot

cd /sys/devices
find -name pcrs | xargs cat

and see whether this displays 24 PCRs. This sends a couple of commands 
to the TPM. Then try a suspend. Did this help anything? If yes, can you 
run above commands again?

FYI: TPM_ContinueSelfTest is the only TPM function that triggers an 
asynchronous action of the TPM, here the continuation of its self test. 
To prevent subsequent commands sent to the TPM from failing due to the 
ongoing self test, we are now waiting for this command to finish. None 
of the machines that I tested it with had a TPM that actually did 
anything during the TPM_ContinueSelfTest() but must have fully completed 
their selftest during TPM_SelfTest() sent to it by the BIOS.

> Revertig this commit on top of the current Linus' tree fixes the problem for me.
>
> If necessary, I'll collect more information about this problem tomorrow.

The output of 'caps' would be interesting in the same dir as pcrs:

cd /sys/devices
find -name caps | xargs cat

    Stefan

