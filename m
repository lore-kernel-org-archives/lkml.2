Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2HNIje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:39:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35720 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HNIjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:39:23 -0400
MIME-Version: 1.0
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 14 Aug 2012 10:38:42 +0200
X-Google-Sender-Auth: C0Y4QQcxbFXGEek4hLucKj4jKmk
Message-ID: <CAH+eYFAJ0FSiZoDiyYJsEg1j-cAhG7DkCwFNJGe5vBNpiUM7ug@mail.gmail.com>
Subject: "regulator: Enable supply regulator if child rail is enabled" broken?
To: ldewangan@nvidia.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        lrg@ti.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that this patch causes incorrect reference counting on supply
regulators if the child regulator is enabled with for example boot_on=true:

commit b2296bd43e781976743354c668a356b0df98e1da
Author: Laxman Dewangan <ldewangan@nvidia.com>
Date:   Mon Jan 2 13:08:45 2012 +0530

    regulator: Enable supply regulator if child rail is enabled.

If a regulator is enabled at boot (by constraints), then this patch calls
regulator_enable() on the supply regulator, leading to a use_count increase on
the supply.  However, this patch adds no code to perform the corresponding
regulator_disable(), leaving the supply regulator on even when all consumers
have disabled it.

AFAICS, this patch would have only worked for always_on regulators.
