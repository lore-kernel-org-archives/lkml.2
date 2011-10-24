Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab1JXOzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:55:41 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:54690 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab1JXOzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:55:40 -0400
Message-ID: <1319468137.3615.16.camel@br98xy6r>
Subject: kdump: crash_kexec()-smp_send_stop() race in panic
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Oct 2011 16:55:37 +0200
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

In our tests we ran into the following scenario:

Two CPUs have called panic at the same time. The first CPU called
crash_kexec() and the second CPU called smp_send_stop() in panic()
before crash_kexec() finished on the first CPU. So the second CPU
stopped the first CPU and therefore kdump failed.

1st CPU:
panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump

2nd CPU:
panic()->crash_kexec()->kexec_mutex already held by 1st CPU
       ->smp_send_stop()-> stop CPU 1 (stop kdump)

How should we fix this problem? One possibility could be to do
smp_send_stop() before we call crash_kexec().

What do you think?

Michael


