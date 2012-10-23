Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab2JWIDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:03:36 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:41738
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756743Ab2JWIDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:03:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz168aJzz1202h1d1ah1d2ahzz17326ah8275bhz2dh668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1155h)
X-WSS-ID: 0MCC6DQ-01-0N6-02
X-M-MSG: 
From: <steffen.schwigon@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <ss5@renormalist.net>, <srostedt@redhat.com>,
        <Dariusz.Filipski@comarch.com>, <yoshitake.kobayashi@toshiba.co.jp>,
        <sassmann@redhat.com>, <andre.przywara@amd.com>,
        <frank.arnold@amd.com>, <conny.seidel@amd.com>, <csd@broadcom.com>,
        Steffen Schwigon <steffen.schwigon@amd.com>
Subject: [PATCH 0/2] RFC: A common test container
Date: Tue, 23 Oct 2012 10:03:00 +0200
Message-ID: <1350979382-19983-1-git-send-email-steffen.schwigon@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Schwigon <steffen.schwigon@amd.com>

OVERVIEW
--------

ABSTRACT: This patch set introduces a mature test library and t/ as a
subdirectory for placing tests that can be run via the existing Linux
tool 'prove' (available in most major Linux distributions). I already
presented and discussed the approach with several people at LinuxCon
Europe 2011 as part of my talk "Linux and virtualization testing".

Tests in t/ are assumed to produce TAP, the "Test Anything Protocol"
(see http://testanything.org) which is well established in many test
communities. The advantage for Linux is that it is easy to generate
which makes it suitable for restricted environments like OS testing.

To write such tests for Linux a library with special utilities is
provided: 'bash-test-utils'.

It provides utility functions to write tests in baremetal and Xen/KVM
contexts (host and guest support) and was polished to work with i686,
x86_64, and ARM under lots of major Linux distributions (Debian,
Ubuntu, RHEL, SLES, Slackware, Fedora, openSUSE). We actively use this
library in all the above contexts for about 2 years.

Other TAP libraries (without special Linux support) are available for
many programming languages.

The autotest project already provides TAP support.


PURPOSE
-------

Provide a container subdir where to place functional tests that are
*in sync* with Linux' git history.

Such tests are usually "unit tests" for features and can also be used
for bisecting regressions of those feature, e.g., by executing 'prove'
with 'ktest' (already part of Linux).

It is possible to organize such tests in a subdir hierarchy (though
not contained with this patch) where separate functional areas as well
as Linux contributors and vendors can be organized without conflicts
and executed separately, for example:

 t/
 t/bare/arch/x86
 t/bare/arch/arm
 t/virt/kvm/
 t/virt/xen/
 t/vendors/fedora/
 t/vendors/companyx/

Separate testprojects like autotest can be kept in sync with the Linux
kernel via git submodules under t/ and called via frontend wrapper
scripts to trigger TAP output.


SYNOPSIS
--------

Testscripts are by convention named "*.t" to be chosen automatically
by 'prove' if executing directories and to differentiate between tests
and other utilities. The subdirectory t/ is also a default convention
used by 'prove'.

Tests can be executed like this:

  $ prove -v t/example/basic.t
  $ prove -v t/example/
  $ prove -r t/


QUESTIONS
---------

Q: Why not submit it to one of the Linux test projects, like LTP or
   autotest?
A: External test projects are not in sync with the Linux kernel. They
   regularly do not fit older or newer kernels.

   Having a test container (subdir t/ with the TAP convention) in
   Linux itself allows

    - contributors, vendors, and companies to place a functional test
      nearby the functionality it belongs to.
    - integrate and sync with existing test projects, e.g., via git
      submodules or wrapper scripts.


Q: Why TAP? Why not XUNIT or other test protocols?
A: There are not that many test protocols. TAP is well established,
   easy, language and platform independent, and already supported in
   every Linux system out-of-the-box. It looks like this:

     1..4
     ok - feature a
     not ok - feature b
     # diagnostic lines with details
     ok - feature c # SKIP not done for this architecture
     not ok - feature d # TODO yet to be implemented

   This can be produced even with the most minimal tools like printf
   from a test inside a strange subsystem, though for practically all
   major programming languages libraries exist. And for evaluating
   tests the tool 'prove' already exists in your Linux system.

   The syntax is easy, yet allows expressing complex test results if
   needed. Besides the #TODO/#SKIP semantics it also allows to embed
   structured data, eg. for benchmark results.


Q: Do we need more framework overhead to execute the tests?
A: Not in the Linux kernel. There are enough tools to execute them:

     - prove ... to run functional tests
     - ktest ... to compile a kernel and boot a machine

   Everything is in place, we just need the common container, per
   convention.


Steffen Schwigon (2):
  bash-test-utils: support writing functional tests
  A common test subdirectory

 t/examples/basic.t                    |   49 ++
 tools/testing/tap/bash-test-utils     | 1508 +++++++++++++++++++++++++++++++++
 tools/testing/tap/bash-test-utils.txt |  320 +++++++
 3 files changed, 1877 insertions(+)
 create mode 100755 t/examples/basic.t
 create mode 100755 tools/testing/tap/bash-test-utils
 create mode 100644 tools/testing/tap/bash-test-utils.txt

-- 
1.7.10.4


