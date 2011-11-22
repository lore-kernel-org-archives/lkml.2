Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1KVKVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:21:54 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:52089 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1KVKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:21:52 -0500
Message-ID: <4ECB77BB.9090401@oracle.com>
Date: Tue, 22 Nov 2011 18:21:47 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: Paul Durrant <paul.durrant@citrix.com>,
        Kurt Hackel <Kurt.Hackel@oracle.com>, ANNIE LI <annie.li@oracle.com>
Subject: Forth version patches for upstreaming grant table version 2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4ECB77BC.0070,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The following patches introduce and implement grant table version 2. 
This is the forth version patches, and based on v3.2.0-rc1+. Changes 
from the previous patches are following:

* Fix an indentation issue of the code.

Descriptions for those patches:

1. In those patches, the grant table code supports both grant table v1 
and v2 version, v2 is an extension from v1. Grant table of guest domain 
can be either v1 or v2 version, and every grant table entry on one guest 
should be the same version.
2. Full page structure of grant table v2 play the same role as grant 
table v1. Although full page structure is different from v1, grant table 
2 is totally backwards compatible with v1. Grant table is shared between 
guest and Xen, domu and dom0 all have their own grant table shared with 
Xen, and their grant table version should be set before any grants are 
activated. When domu grants an entry to dom0 to map a frame,following 
are steps: * domu introduces a grant entry by reference * domu informs 
dom0 the gref * dom0 sends hypercall to map frame through this 
reference, Xen copy shared entry to active entry and update frame * dom0 
does its work and release the frame, Xen releases the entry. * domu redo 
those steps for a new cycle. Xen mapping process can be found in 
function __gnttab_map_grant_ref in Xen code: xen/common/grant_table.c

3. If dom0 supports grant table v2, guests run on it can either supports 
v1 or v2. Xen is responsible to judge what  version the guests are 
using. This is implemented in Xen code: xen/common/grant_table.c. Key 
word is:  rd->grant_table->gt_version.
4. Grant table v2 has been supported by Xen for a long time, and 
receiver-side copying mechanism bases on this implementation. Netback 
and netfront driver can pick up this new feature to get better network 
performance and better CPU accounting.

Diff:

  arch/x86/xen/grant-table.c          |   42 ++++-
  drivers/xen/grant-table.c           |  354 
++++++++++++++++++++++++++++++-----
  include/xen/grant_table.h           |   10 +-
  include/xen/interface/grant_table.h |  167 ++++++++++++++++-
  include/xen/interface/xen.h         |    2 +
  5 files changed, 519 insertions(+), 56 deletions(-)

Shortlog:

Annie Li (4):
       xen/granttable: Introducing grant table V2 stucture
       xen/granttable: Refactor some code
       xen/granttable: Grant tables V2 implementation
       xen/granttable: Keep code format clean

Thanks
Annie
