Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2DYT2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 15:28:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37455 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623Ab2DYT1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 15:27:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/3] PM / Domains: Fix device stop and domain power off governor functions, take 2
Date: Wed, 25 Apr 2012 21:28:32 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>,
        Simon Horman <horms@verge.net.au>
References: <201204242349.26288.rjw@sisk.pl>
In-Reply-To: <201204242349.26288.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204252128.33016.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Tuesday, April 24, 2012, Rafael J. Wysocki wrote:
> Hi all,
> 
> It turns out that the PM domains device stop and domain power off governor
> functions I invented some time ago don't really make sense, because they
> should only decide whether or not the resulting low-power state will be
> too deep and that only depends on latencies.  In particular, the time
> when devices have been suspended doesn't really matter here, so the
> results returned by those functions shouldn't depend on it either (as it
> shouldn't depend on any "break even" values that only make sense when we
> know how much time in advance the device is going to be used, but this
> information is not related to the PM QoS latency constraint).
> 
> If this functions are fixed (patches [1/3] and [2/3]), then some ugly
> computations can be removed from rpm_suspend() and other places and the
> whole framework can be simplified quite a bit (patch [3/3]).

I noticed a few problems with the patches sent yesterday.  Most importantly:

* dev_pm_qos_read_value() should be used rather than its unlocked counterpart.
* All children of the device have to be taken into account, not only those
  belonging to generic PM domains.
* default_power_down_ok() should take restore_state_latency_ns into account.
* default_power_down_ok() should not assume that default_stop_ok() will always
  be called before it (the domain may choose to use a different device stop
  governor function in principle).
* rpm_resume() still should check the devices PM QoS constraint and return
  error code if the value is negative (which means never suspend).

Updated patches follow.

Thanks,
Rafael

