Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab2GLGDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:03:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49612 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab2GLGDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:03:30 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-77-4ffe68b0867f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] charger-manager: Use EXTCON Subsystem to control charger
 cable
Date: Thu, 12 Jul 2012 15:03:16 +0900
Message-id: <1342072996-9391-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jQd2NGf/8DfZOYrO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ545cYyw4yV9x5t8UtgbGxzxdjJwcEgImEof3bGKEsMUkLtxb
	z9bFyMUhJDCdUWLLk42sEM5SJom5vTdZQKrYBLQk9r+4wQZiiwjISbxe+5cJpIhZ4BSjxKOL
	J5hBEsICoRIPu48xgdgsAqoSs8++AbN5BVwknmzdzwyxTkGiddkh9gmM3AsYGVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBHvxmdQOxpUNFocYBTgYlXh4L0b+8xdiTSwrrsw9xCjBwawk
	wusIEuJNSaysSi3Kjy8qzUktPsQozcGiJM5r7P3VX0ggPbEkNTs1tSC1CCbLxMEp1cC4cvbJ
	S8evXC2/rSnRFvnit3bUnreXN2Vl1wnOOfZGPfat/Lkf81TnTTHojJq6W7yDufrCF/GYiezr
	5ubMlZVMcN5feHOOr/bNTf1cm1NXOXYI3d+yz0PHVyVZZNu3W3JBKr/2lBSxO6u6l3et/73p
	s4RwbLTY10W7GuY6bTDN91N4xjfndvlNJZbijERDLeai4kQAl6gqUd4BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add support EXTCON Subsystem in which charger-manager identify
the type of external connector and enable/disable charger(regulator) according
to the state of charger cable(external connector).

First patch control charger(regulator) of charger-manager when external
connector is attached or detached. If USB/TA cable is attached and thenE XTCON
subsystem notify the state of external connector to notifee(charger-manager)
which is registered in notifier chain of EXTCON, charger-manager enable charger
(regulator) for charging according to 'struct charger_cable'.

Second patch protect host device from over current. The charger-manager
set proper current limit of charger(regulator) for charging according to
type of charger cable when external connector is attached.

For example, if TA cable(external connector) is attached, charger-manager
enable charger('vinchg1' regulator) and set limit current within 65000~675000uA.

static struct charger_cable charger_cable_vinchg1[] = {
	{
		.extcon_name	= "max8997-muic",
		.name		= "USB",
		.min_uA		= 475000,
		.max_uA		= 475000 + 25000,
	}, {
		.extcon_name	= "max8997-muic",
		.name		= "TA",
		.min_uA		= 650000,
		.max_uA		= 650000 + 25000,
	},
};

static strcut charger_regulator nuri_regulators[] = {
	{
		.regulator_name	= "vinchg1",
		.cables		= charger_cable_vinchg1,
		.num_cables	= ARRAY_SIZE(charger_cable_vinchg1),
	},
};

static struct charger_desc nuri_charger_desc = {
	// ......

	.charger_regulators	= nuri_regulators,
	.num_charger_regulators	= ARRAY_SIZE(nuri_regulators),
};

Chanwoo Choi (2):
  charger-manager: Use EXTCON Subsystem to detect charger cables for
    charging
  charger-manager: Set current limit of regulator for over current
    protection

 drivers/power/charger-manager.c       |  152 +++++++++++++++++++++++++++++----
 include/linux/power/charger-manager.h |   67 ++++++++++++++-
 2 files changed, 202 insertions(+), 17 deletions(-)

