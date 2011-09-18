Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab1IRNTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 09:19:51 -0400
Received: from gob75-8-88-165-216-99.fbx.proxad.net ([88.165.216.99]:44717
	"EHLO smtp-1.httrack.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab1IRNTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 09:19:50 -0400
X-Greylist: delayed 2200 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Sep 2011 09:19:50 EDT
X-Spam-Filter: check_local@smtp-1.httrack.com by digitalanswers.org
Message-ID: <4E75E754.2080900@httrack.com>
Date: Sun, 18 Sep 2011 14:43:00 +0200
From: Xavier Roche <roche*lkml@httrack.com>
Organization: Nowhere Corp.
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Follow-up to routing IPv6 source address selection bug in kernel
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (smtp-1.httrack.com [192.168.1.100]); Sun, 18 Sep 2011 14:43:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I reported a year ago a bug regarding source address selection in the
kernel for Ipv6, but it seem to be still there. If anyone has any
insightful advice on possible workarounds, or (better) possible fixes,
it would be great.

Basically, the "src" attribute of "ip -6 route add" is ignored, and
default source address selection is selected by the kernel.

This is probably related to the way the kernel handles RFC 3484 source
address selection [ The RFC states that [RFC 3484] "If the eight [source
address selection] rules fail to choose a single address, some
unspecified tie-breaker should be used". The unspecified tie-breaker
would then be the src routing information, or any additional netfilter
setting. ]

Selecting the source address according to outgoing parameters
(destination network, destination protocol, for example, but it could be
running uid/gid with advanced netfilter rules) is kind of handy when you
want to have dedicated addresses for, say, outgoing SMTP, outgoing HTTP,
outgoing SSH and so on..

This is especially true with IPv6: the default allocated size is at
least 16 billions billions IP addresses. Being able to use more than one
address per server is then kind of handy.

Binding to a special IP address for outgoing connections is difficult in
most cases, because the application would have to do the logic the
kernel is computing normally (destination on local network ? or on the
same interface ..) and would prevent proper use when multiple
interfaces/networks are in use.

The simplest way to achieve that would be to build a dedicated route for
a specific netblock, for example (this would not solve the
"per-destination-protocol" case, but this is a beginning). As I said
before, it unfortunately does not work.

Note that:

- Marking packets and using policy-based routing is not possible either
(as I understood, the source address has already been computed at this
point and the packet is built, so this is too late)

- Source NATing is also impossible (not implemented on IPv6)

- The /etc/gai.conf tuning file is no help for this purpose either.

I understand this is not a major kernel issue, but this is a really
annoying limitation when you have an almost infinite address space unused :)

[ Note: see also "src attribute ignored for IPv6 (preferred source
address selection)" in linux-netdev mailing-list one year ago. ]
