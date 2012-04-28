Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2D1Upu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 16:45:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36741 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab2D1Upt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 16:45:49 -0400
From: Alexander Tarasikov <alexander.tarasikov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie
Subject: [PATCH] drivers:gpu:vga_switcheroo: Work around dramatic power drain 
Date: Sun, 29 Apr 2012 00:45:27 +0400
Message-Id: <1335645928-30993-1-git-send-email-alexander.tarasikov@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello! Many modern laptops featuring hybrid graphics show a huge raise in
power drain after a suspend/resume cycle which is caused by the discrete
adapter ignoring ACPI-issued power off call after a resume.

This behaviour (increase in power consumption) has been observed on several
machines by many users. This machines include Thinkpad X220, HP Elitebook and
Sony VAIO series, so this may apply to all laptops.

One of the workarounds is to do an ON/OFF cycle via switcheroo from userland
on each resume but this causes confusion in the VGA BIOS which thinks the card
is already ON and that leads to the GPU lockup and system slowdown for a minute
or so. This kind of behaviour is absolutely unacceptable.

I propose this patch as a workaround. It creates a new module parameter
(vga_switcheroo.resume_powercut). When it is set to 1, on resume the driver
will iterate over the list of registered cards and disable all inactive cards
ignoring their power state in switcheroo struct (ON/OFF).

I have tested this on my laptop (which is Sony VAIO SA3S9R with i5, HM67,
HD3000 and Radeon 6630M).
Without this patch, the idle power consumption is 7-9W. After a suspend/resume
cycle that jumps to 15-19W. With the patch, the consumption is always below
10W after numerous suspend/resume cycles.

I agree that the implementation may be far from clean, therefore I have
not enabled the parameter by default. I am welcome to any suggestions on
improving the implementation but I think that it would not hurt to include
it as-is so that users can test it and report their impressions/bugs. Please
review the patch and forward it to downstream projects if you are involved in
any that may be interested (i.e., ubuntu kernel team).
