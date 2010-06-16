Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0FPJcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:32:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38344 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab0FPJcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:32:41 -0400
Subject: Enabling a disabled hw-breakpoint using modify_user_hw_breakpoint
From: Will Deacon <will.deacon@arm.com>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 10:32:35 +0100
Message-ID: <1276680755.26231.16.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2010 09:32:38.0699 (UTC) FILETIME=[DC61E7B0:01CB0D36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

In the ARM hw-breakpoint implementation, the ptrace API may create a new
breakpoint with attr->disabled = 1. At a later time, this may be updated
to 0 and modify_user_hw_breakpoint will be called to propagate the
changes.

As part of this callchain, the architecture-specific function
arch_validate_hwbkpt_settings is called with the breakpoint as a
parameter. The attr->disabled field is checked and the corresponding
`enabled' field in the ARM control register struct is set accordingly.

When arch_install_hw_breakpoint is called later on, the actual control
register is programmed with the values set in the struct. The problem is
that modify_user_hw_breakpoint doesn't update the bp->attr.disabled
field before calling the validate function:


	if (attr->disabled)
		goto end;

	/* bp->attr.disabled still has the old value */
	err = validate_hw_breakpoint(bp);
	if (!err)
		perf_event_enable(bp);

	if (err) {
		bp->attr.bp_addr = old_addr;
		bp->attr.bp_type = old_type;
		bp->attr.bp_len = old_len;
		if (!bp->attr.disabled)
			perf_event_enable(bp);

		return err;
	}

end:
	bp->attr.disabled = attr->disabled;


For the time being, I always write the control register enable bit in
arch_install_hw_breakpoint (because this function shouldn't be called if
the breakpoint is disabled). Is this a sensible workaround, or does the
generic code need changing?

Thanks,

Will

