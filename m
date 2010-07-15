Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934977Ab0GOXJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:09:59 -0400
Received: from exprod6og117.obsmtp.com ([64.18.1.39]:46305 "HELO
	exprod6og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933383Ab0GOXJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:09:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
x-cr-hashedpuzzle: E1Zl GS+l ITnr K0n2 Mnqh Mn6v M8Fd Q341 TK4S TaIn VNAv XHlB XuV2 ZPIb aQ6R dCQu;3;YwBoAGUAdABhAG4AbABvAGsAZQBAAGcAbQBhAGkAbAAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG4AZQB0AEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{1717ADF9-9AB0-40D2-AC82-CCE83C53E6E7};YwBoAGUAdABhAG4ALgBsAG8AawBlAEAAbgBlAHQAcwBjAG8AdQB0AC4AYwBvAG0A;Thu, 15 Jul 2010 23:09:48 GMT;WwBSAEYAQwBdACAARQBuAGgAYQBuAGMAZQAgAGQAZQB2AF8AaQBvAGMAdABsACAAdABvACAAcgBlAHQAdQByAG4AIAA8AGgAdwBhAGQAZAByAD4AOgA8AGkAZgBfAG4AYQBtAGUAOgA6AGkAZgBfAGkAbgBkAGUAeAA+ACAAbQBhAHAAcABpAG4AZwA=
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
x-cr-puzzleid: {1717ADF9-9AB0-40D2-AC82-CCE83C53E6E7}
Content-class: urn:content-classes:message
Subject: [RFC] Enhance dev_ioctl to return <hwaddr>:<if_name::if_index> mapping
Date: Thu, 15 Jul 2010 19:09:48 -0400
Message-ID: <D3F292ADF945FB49B35E96C94C2061B90C49F936@nsmail.netscout.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC] Enhance dev_ioctl to return <hwaddr>:<if_name::if_index> mapping
Thread-Index: AcskctJagkQxJ/kIRru8s62UMhhz8w==
From: "Loke, Chetan" <Chetan.Loke@netscout.com>
To: <linux-kernel@vger.kernel.org>, <linux-net@vger.kernel.org>,
        <chetanloke@gmail.com>
X-OriginalArrivalTime: 15 Jul 2010 23:09:53.0983 (UTC) FILETIME=[D5AB34F0:01CB2472]
X-TM-AS-Product-Ver: SMEX-8.0.0.4125-6.000.1038-17506.004
X-TM-AS-Result: No--12.980300-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

LKML Post:
http://kerneltrap.org/mailarchive/linux-kernel/2010/7/12/4592938


This proposal will provide the ability to shoot an 'ioctl' via an 'ethX'
agnostic naming scheme.

Requirement:
R1)Ability to address NICs/interfaces using a mac-addr in ioctls. This
is required because we don't have a consistent naming scheme for
Ethernet devices.
   Asking customers and/or field-engineers to change udev rules and
other config files is not feasible.

Existing pain-points:
P1) ioctl needs either i) if-name or ii) if-index before we can invoke
bind() etc. 
    This works fine if you know your configuration and it is not going
to change.    
    However,if we hot-add a NIC and if you have adapters from multiple
vendors(think:driver load order) then upon a reboot,
    the 'eth' interfaces can be re-mapped.

Existing work-around(s):
W1) user-apps scan /sys/class/net/ethX/address nodes, grep the hw-addrs
till they find a hwaddr-match and then internally create a hwaddr-ethX
mapping table.
W2) change udev-70..persistent rules file and 'rename' the interfaces
according to your needs.
    W2.1) If renaming were to even succeed then none of the existing
drivers re-register their msix-vectors.
    NETDEV_RENAME(or _CHANGE ) handler in the driver does not tear down
the interrupts etc.
    Some of the sample msix-vectors are as follows : ethX-rx-0,
ethX-rx-1 ... ethX-rx-N
    So if the interface is renamed then how do we measure/correlate the
interrupt-count?

But there is no programmatic way of deriving the 'ethX' name. I got a
few offline replies to the above post, asking me to continue using W1)
from above. 
Sorry but that was an ugly hack. Also why not replace the get-ioctls to
a 'sys' read everywhere?? ;).

Solution/Proposal:
S1)   Introduce a new ioctl(SIOCGHWADDR_TO_IFNAMEINDEX_MAP[or pick your
name])
S1.1) Enhance dev_ioctl to handle this new case.
S1.2  Re-use for_each_netdev_rcu::is_etherdev_addr(this will iterate
through dev_addrs).
      By using the above for_each loop we don't need to re-invent the
wheel.

Input(ifr->hw_addr) : output -> if_name and if_index if ifr->hw_addr is
found.

This way an app can first shoot down an ioctl(sock_fd,
SIOCGHWADDR_TO_IFNAMEINDEX_MAP,ifr), where ifr.ifr_hwaddr is populated
w/ the mac_addr whose mapping you would like.
Then once the if_name and if_index is known, using other ioctls is easy.


Please review the proposal and the sample code below. If this is not a
good approach and if there is a simple workaround then please let me
know.


Regards
Chetan Loke


----------------------------------------------------------

Sample code(PS- I used a quick and dirty driver to demonstrate the
concept rather than modifying the kernel)


Copyright NetScout Systems
Chetan Loke <loke.c@alumni.neu.edu>

struct foo {
	char name[IFNAMSIZ];
	int  index;
};

/* shamelessly copied from compare_etherdev */
/* eventually is_etherdev_equal will be called by dev_ioctl */
int ntct_is_etherdev_equal(u16 *a,u16 *b) {
	return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | (a[2] ^ b[2])) == 0;
}

/* eventually enhance dev_ioctl */
int _do_ioctl(unsigned long arg) {

	struct foo my_foo;
	struct net_device *dev;
	int ret=0;
	int found=0;
	int i=0;
	
	/* eventually sent via
ioctl(sock_fd)->SIOCG_HWADDR_TO_NAMEIDX_MAP and ifr->hw_addr */
	unsigned char mac_addr[]={0x00,0x50,0x56,0xBB,0x52,0xF7};

	/* eventually use rcu_read_lock(); */
	read_lock(&dev_base_lock);
	
	/* 2.6.31 doesn't have this defined. eventually use
for_each_netdev_rcu. */
	for_each_netdev(&init_net, dev) {
		dev_hold(dev);
		
		/* eventually use is_etherdev_addr(addr1,addr2) */
		ret = ntct_is_etherdev_equal((u16 *)dev->dev_addr,(u16
*)mac_addr);
		if (ret) {
			printk("<%s> Found eth-if:%s
ifindex:%d\n",__func__,dev->name,dev->ifindex);
			printk("Mac:");
			for (i=0;i<ETH_ALEN;i++)
				printk("%02x%c",(unsigned
char)dev->dev_addr[i],((i < 5)? ':':' '));
			printk("\n");
			strcpy(my_foo.name,dev->name);
			my_foo.index=dev->ifindex;
			dev_put(dev);
			found=1;
			break;
		}
		dev_put(dev);
	}

	/* eventually use rcu_read_unlock(); */
	read_unlock(&dev_base_lock);
	
	if (!found) {
		printk("<%s> hwaddr<->name mapping not
found\n",__func__);
		return -EINVAL;
	}

	return copy_to_user((char *)arg,&my_foo,sizeof(struct foo)) ?
-EFAULT : 0;
}

