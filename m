Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1KIIMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:12:25 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:39581 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1KIIMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:12:23 -0500
Message-ID: <4EBA35D3.3020506@oracle.com>
Date: Wed, 09 Nov 2011 16:12:03 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, jeremy@goop.org
CC: Paul Durrant <paul.durrant@citrix.com>,
        Kurt Hackel <Kurt.Hackel@oracle.com>
Subject: patches of upstreaming grant table version 2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4EBA35E3.00D6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The following patches introduce and implement grant table version 2, and 
they are based on v3.1.0-rc9+.

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
activated. When domu grants an entry to dom0 to map a frame, following 
are steps:
* domu introduces a grant entry by reference
* domu informs dom0 the gref
* dom0 sends hypercall to map frame through this reference, Xen copy 
shared entry to active entry and update frame
* dom0 does its work and release the frame, Xen releases the entry.
* domu redo those steps for a new cycle.

Xen mapping process can be found in function __gnttab_map_grant_ref in 
link: 
http://xenbits.xen.org/hg/xen-4.1-testing.hg/file/81e39a4978ea/xen/common/grant_table.c#l2172 


3. If dom0 supports grant table v2, guests run on it can either supports 
v1 or v2. Xen is responsible to judge what version the guests are using. 
This is implemented in link: 
http://xenbits.xen.org/hg/xen-4.1-testing.hg/file/81e39a4978ea/xen/common/grant_table.c#l2172. 
Key word is:  rd->grant_table->gt_version.

4. Grant table2 is a precondition to netchannel2 mechanism. Netchannel2 
imports a new device type: vif2. To support this type, we need new 
netback2, netfront2 driver and modification in Xen. If all are ready, 
two types of vif can be supported: vif and vif2. vif is for original 
backend and frontend, vif2 is for netback2 and netfront2.

Thanks
Annie
