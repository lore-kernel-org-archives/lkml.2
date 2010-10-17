Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab0JQSFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:05:43 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44264 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab0JQSFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=AjLsbdlN+12wBI//jFyfmMEeR9x0CrdxuNldr7pR6q6CEN0y1m5Kay9ZCp63wA/fuN
         CE+idX8lb0Pc3gNzSaTstbHWqof8VqKZYrJ41XJU2e73aL8R+zFIKxpK427bJ6jBk+aY
         KYuK9d6H36qgEukdwRrc824+ZddV7blYQn770=
Message-ID: <4CBB3B24.2000106@gmail.com>
Date: Sun, 17 Oct 2010 14:06:28 -0400
From: Benjamin Poirier <benjamin.poirier@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: bridge@lists.linux-foundation.org
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: EAPOL bridging
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have some trouble bridging EAPOL frames. I'd like to do this to allow 
wired 802.1x authentication from within a kvm virtual machine. I have 
the following setup:

kvm -- tap0 -- br0 -- eth1 -- 802.1x authenticator (switch) -- more network

and it doesn't work. I've added a few logging rules to ebtables. I only 
see an EAPOL frame going through the INPUT chain of tap0. It seems to be 
dropped by the bridge. The EAPOL frame is an ethernet link local 
multicast frame with destination address 01-80-C2-00-00-03, "IEEE Std 
802.1X PAE address".

I've looked at http://standards.ieee.org/regauth/groupmac/tutorial.html, 
which says that frames with a destination in the range 01-80-C2-00-00-00 
to 01-80-C2-00-00-0F should not be forwarded by standard conformant 
bridges. I've also looked at net/bridge/br_input.c and br_handle_frame() 
seems quite intent on "bending" the standard when STP is disabled, but 
only for 01-80-C2-00-00-00. However there are more applications that use 
similar addresses, EAPOL included: 
http://standards.ieee.org/regauth/groupmac/Standard_Group_MAC_Address_assignments.pdf

Given the current state of affairs, would it be acceptable to make the 
code more permissive by forwarding all the range of reserved group 
addresses when STP is disabled? If not, what would be the way to go 
about enabling 802.1x authentication from within a virtual machine?

BTW, it seems this issue has been raised before, 
https://lists.linux-foundation.org/pipermail/bridge/2007-November/005629.html
with the conclusion that
> Despite what the standards say, many users are using bridging code for invisible
> firewalls etc, and in those cases they want STP and EAPOL frames to be forwarded.

Thanks,
-Ben
