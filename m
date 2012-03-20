Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2CTUKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:10:24 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:42267 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755769Ab2CTUKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:10:21 -0400
Message-ID: <4F68E420.30801@xenotime.net>
Date: Tue, 20 Mar 2012 13:10:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joel Reardon <joel@clambassador.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] Add design document for UBIFS secure deletion
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>  <1329152067.22240.214.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>  <alpine.DEB.2.00.1202231628360.13720@eristoteles.iwoars.net> <1331277476.22872.2.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1203191752300.22256@eristoteles.iwoars.net>
In-Reply-To: <alpine.DEB.2.00.1203191752300.22256@eristoteles.iwoars.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 09:54 AM, Joel Reardon wrote:


Nice job overall.  I have just a few comments below.


> Design document should be self explanatory.
> 
> Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
> 
> ---
>  Documentation/filesystems/ubifsec.txt |  358 +++++++++++++++++++++++++++++++++
>  1 files changed, 358 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/filesystems/ubifsec.txt
> 
> diff --git a/Documentation/filesystems/ubifsec.txt b/Documentation/filesystems/ubifsec.txt
> new file mode 100644
> index 0000000..4eb41fb
> --- /dev/null
> +++ b/Documentation/filesystems/ubifsec.txt
> @@ -0,0 +1,357 @@
> +UBIFS Secure Deletion Enhancement
> +
> +Written by Joel Reardon <reardonj@inf.ethz.ch>
> +Last revised: 19.3.2012
> +
> +Introduction
> +============





...

> +Key State Map
> +=============



...

> +The operation of purging performed on a correct key state map guarantees
> +DNEFS's soundness: purging securely deletes any key in the KSA marked as




What is DNEFS?

> +deleted---afterwards, every key either decrypts one valid data node or nothing
> +at all and every valid data node can be decrypted.  A correct key state map
> +also guarantees the integrity of our data during purging, because no key that
> +is used to decrypt valid data will be removed.
> +




...

> +
> +The key state map is built from a periodic checkpoint combined with a replay
> +of the most recent changes while mounting.  We checkpoint the current key
> +state map to the storage medium whenever the KSA is purged. After a purge,
> +every key is either unused or used, and so a checkpoint of this map can be
> +stored using one bit per key---less than 1\% of the KSA's size---which is then




drop '\' ?

> +compressed.  A special LEB is used to store checkpoints, where each new




What is LEB?

> +checkpoint is appended; when the erase block is full then the next checkpoint
> +is written at the beginning using an atomic update.
> +
> +Correctness of the Key State Map
> +================================




...

> +Second, failure can occur after purging one, several, or indeed  all of the
> +KSA's LEBs. When remounting the device, the loaded checkpoint merged with the
> +replay data  reflects the state before the first purge, so some purged LEBs
> +contain new unused data while the key state map claims it is a deleted key. As
> +these are cryptographically-suitable random values, with high probability they
> +cannot successfully decrypt any existing valid data node.




Last sentence seems to be incomplete or just odd.

> +
> +Third, failure can occur while writing to the checkpoint LEB.  When the
> +checkpoint is written using atomic updates, then failing during the operation
> +is equivalent to failing before it begins (cf. 2nd case).  Incomplete




s/cf./compare/
No need to save the space and lots of people probably won't know what
cf. is.

> +checkpoints are detected and so the previous valid checkpoint is loaded
> +instead.  After replaying all the nodes, the key state map is equal to its
> +state immediately before purging the KSA. This means that all entries marked
> +as deleted are actually unused entries, so the invariant holds.



-- 
~Randy
