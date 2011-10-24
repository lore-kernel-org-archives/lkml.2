Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab1JXPN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:13:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40920 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1JXPN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:13:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: holzheu@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, akpm@linux-foundation.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1319468137.3615.16.camel@br98xy6r>
Date: Mon, 24 Oct 2011 08:14:16 -0700
In-Reply-To: <1319468137.3615.16.camel@br98xy6r> (Michael Holzheu's message of
	"Mon, 24 Oct 2011 16:55:37 +0200")
Message-ID: <m1ipneifqv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/8IkEzk5IXV7LRCTtMBmWd0Xg+EI0W8Tk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;holzheu@linux.vnet.ibm.com
X-Spam-Relay-Country: **
Subject: Re: kdump: crash_kexec()-smp_send_stop() race in panic
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Holzheu <holzheu@linux.vnet.ibm.com> writes:

> Hello Vivek,
>
> In our tests we ran into the following scenario:
>
> Two CPUs have called panic at the same time. The first CPU called
> crash_kexec() and the second CPU called smp_send_stop() in panic()
> before crash_kexec() finished on the first CPU. So the second CPU
> stopped the first CPU and therefore kdump failed.
>
> 1st CPU:
> panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump
>
> 2nd CPU:
> panic()->crash_kexec()->kexec_mutex already held by 1st CPU
>        ->smp_send_stop()-> stop CPU 1 (stop kdump)
>
> How should we fix this problem? One possibility could be to do
> smp_send_stop() before we call crash_kexec().
>
> What do you think?

smp_send_stop is insufficiently reliable to be used before crash_kexec.

My first reaction would be to test oops_in_progress and wait until
oops_in_progress == 1 before calling smp_send_stop.

Eric
