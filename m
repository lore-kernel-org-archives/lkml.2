Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2JQODv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:03:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18224 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab2JQODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:03:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, hpa@zytor.com,
        x86@kernel.org
Subject: [RFC] ACPI S3 and Xen (suprisingly small\!).
Date: Wed, 17 Oct 2012 09:49:42 -0400
Message-Id: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> # This line is ignored.
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [RFC] ACPI S3 and Xen (surprisingly small\!).
In-Reply-To: 

Hey,

Way back at the LinuxPlumbers 2012 I chatted with Len about the issue
with Xen and Linux not working very well when suspending. We did a bit
of brainstorming and armed with these ideas I started looking at this.

The end result is this is a nice set of patches where there is only
_one_ change in the x86 code (and it is just more of dealing with
error case) - and the rest are all done in Xen side.

The change is to check whether there is a TSS GDT descriptor before
trying to set it. On 64-bit Xen there is no TSS and we ignore any
calls to set such field.

The bulk of the Xen code is filling out some of the pvops calls
(some of them are already in v3.7-rc1), and one to "prep" the cr3
value so that the hypervisor is fine with it.

Note: These are the other patches that went in 3.7-rc1:
xen/bootup: allow {read|write}_cr8 pvops call [https://lkml.org/lkml/2012/10/10/339]
xen/bootup: allow read_tscp call for Xen PV guests. [https://lkml.org/lkml/2012/10/10/340]

Anyhow, with these patches ACPI S3 suspend/resume of Linux works great!

 arch/x86/power/cpu.c     |    7 +++++--
 arch/x86/xen/enlighten.c |   24 ++++++++++++++++++++++--
 drivers/xen/acpi.c       |   25 +++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 4 deletions(-)
