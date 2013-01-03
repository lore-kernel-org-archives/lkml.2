Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3ADAHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:07:49 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59170 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab3ADAHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/12] ACPI: Rework the handling of power resources
Date: Fri, 04 Jan 2013 00:16:48 +0100
Message-ID: <1418767.4KIZOTK1lk@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

There are some problems with our handling of ACPI power resources that have
accumulated over time or have never been addressed.

First of all, the interface represented by
acpi_power_resource_[un]register_device() doesn't really work as it should,
so it needs to be redesigned (details in the changelog of patch [1/12]).

Second, power resources really have to be treated in a special way by the
ACPI namespace scanning code, because they may need to be ready to use as
soon as they are discovered.  Moreover, the are represented by struct
acpi_device objects, so that they appear in sysfs along with "regular" ACPI
device nodes, they really don't represent devices, so they need special
configuration treatment in some cases.  This special casing is obnoxiously
present in scan.c, but if we accept the fact that power resources really are
a special case, things can be simplified quite a bit (patch [3/12] with some
preparations in [2/12]).

If the above changes are made, then it turns out that the entire
acpi_power_driver structure is not necessary any more and we don't need the
device power states of power resources for anything (patches [4-5/12]).

Moreover, ACPI power resources are supposed to be ordered.  Namely, they have
an attribute defining the order in which they are supposed to turned on and
off.  Currently, though, we don't take that attribute into accound, although
we obviously should do that.  After the previous changes that may be
implemented at a relatively low cost (patch [6-7/12]).

Patches [8-9/12] move code around and clean it up in preparation for patch
[10/12], which consolidates the way in which power resources lists are
extracted from the output of _PRW and _PR[0-3].

Patch [11/12] improves the handling of power resource initialization errors
and patch [12/12] causes the system level attribute of wakeup power resources
to be taken into account during device setup.

All patches are on top of the git branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next

Tested on HP nx6325 (and other boxes where ACPI power resources aren't used).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
