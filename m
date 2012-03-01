Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab2CANlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:41:35 -0500
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:35433
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755886Ab2CANle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:41:34 -0500
Date: Thu, 1 Mar 2012 14:41:31 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Adding Secure Deletion to UBIFS
In-Reply-To: <1330536308.3545.158.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203011434220.2462@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net> <1330536308.3545.158.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is true. The reason its done is as an optimization for the 
following reason.

When deleting a data node, the key position is marked as deleted. The key 
positions then requires a datanode read to find. By keeping it in memory (thus the TNC), 
marking a key pos as deleted doesn't require a flash read. This improves 
e.g., truncations and full file deletion speed, which would otherwise read 
each data node from flash to get the positions. If it is not stored in 
ubifs_branch (but still stored in the tree), then it would have to be 
loaded once 'on-demand' after mounting. This is also an option, of course. 
Currently, deleting a file performs a walk on all the TNC's data nodes 
that are removed, so the extra mark-delete incurs no observable cost.

Cheers,
Joel Reardon

On Wed, 29 Feb 2012, Artem Bityutskiy wrote:

> On Thu, 2012-02-09 at 16:24 +0100, Joel Reardon wrote:
>>
>> Each data nodes includes a reference to a key in the KSA. This key is read and
>> used to decrypt the data. When a new data node is written, an unused key is
>> selected from the KSA and used to encrypt the data node. The reference to the
>> key is then included with the node. The keys in the KSA are written before
>> actually being used to encrypt data. To securely delete a data node, we simply
>> mark the corresponding key position as deleted, and during the next purging
>> operation the KSA erase block that contains the key is then updated to a
>> version that does not contain the key.
>
> Why do you need to have your '__u64 crypto_lookup' both in the data node
> and the index? Isn't it enough to have them only inside the data nodes?
> ubifs_branch anyway points to the data node and you can read your
> 'crypto_lookup' from there.
>
> -- 
> Best Regards,
> Artem Bityutskiy
>
