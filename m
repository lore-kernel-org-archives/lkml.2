Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab1HKMsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:48:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:31163 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1HKMsG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 11 Aug 2011 08:48:06 -0400
Message-Id: <4E43EBDF0200007800050CA7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 11 Aug 2011 13:49:03 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <tj@kernel.org>
Cc: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: x86_32_early_logical_apicid() -> one warning per CPU on
	 late-determined BIGSMP systems
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

with generic_processor_info() getting run before generic_bigsmp_probe(),
the values obtained by the former though apic->x86_32_early_logical_apicid()
(still pointing to default_x86_32_early_logical_apicid() at that time) and
stored into early_per_cpu(x86_cpu_to_logical_apicid, cpu) can't possibly
match the ones obtained by setup_local_APIC() (since only at this point
apic->x86_32_early_logical_apicid() points to bigsmp_early_logical_apicid()),
thus causing the warning there to generally trigger on each CPU.

Except for removing the warning, all other possible solutions to this that
I can think of seem ugly to me (i.e. somehow re-initializing
x86_cpu_to_logical_apicid for all CPUs), but I wonder why setting up
x86_cpu_to_logical_apicid needs to be done this early if prior to
setup_local_APIC() doing it a second time the value can't be used for
anything anyway (because it could validly be BAD_APICID). If there
aren't any future plans (honestly, I can't really make much sense of
commit acb8bc09c6185e4d3d582d0076aaa6a89f19d8c5's comment),
perhaps x86_32_early_logical_apicid() could get removed again?

Jan

