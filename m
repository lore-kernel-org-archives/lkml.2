Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab2AFLpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:45:21 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:52714 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648Ab2AFLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:45:20 -0500
Date: Fri, 6 Jan 2012 14:45:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: static check complains about potential oops in adfs_read_map()
Message-ID: <20120106114503.GA1540@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F06DEC9.004C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My static checker is complaining about potential oops in adfs.  I don't
know the code well enough to say if it's a real bug or what the correct
fix is.

fs/adfs/super.c
   299          nzones    = asb->s_map_size;
                            ^^^^^^^^^^^^^^^
This could be zero.  We read it from the disk.  I don't see any place
where it's checked.

   300          zone_size = (8 << dr->log2secsize) - le16_to_cpu(dr->zone_spare);
   301          map_addr  = (nzones >> 1) * zone_size -
   302                       ((nzones > 1) ? ADFS_DR_SIZE_BITS : 0);
   303          map_addr  = signed_asl(map_addr, asb->s_map2blk);
   304  
   305          asb->s_ids_per_zone = zone_size / (asb->s_idlen + 1);
   306  
   307          dm = kmalloc(nzones * sizeof(*dm), GFP_KERNEL);
   308          if (dm == NULL) {
   309                  adfs_error(sb, "not enough memory");
   310                  return NULL;
   311          }
   312  
   313          for (zone = 0; zone < nzones; zone++, map_addr++) {
   314                  dm[zone].dm_startbit = 0;
   315                  dm[zone].dm_endbit   = zone_size;
   316                  dm[zone].dm_startblk = zone * zone_size - ADFS_DR_SIZE_BITS;
   317                  dm[zone].dm_bh       = sb_bread(sb, map_addr);
   318  
   319                  if (!dm[zone].dm_bh) {
   320                          adfs_error(sb, "unable to read map");
   321                          goto error_free;
   322                  }
   323          }
   324  
   325          /* adjust the limits for the first and last map zones */
   326          i = zone - 1;
   327          dm[0].dm_startblk = 0;
                ^^^^^
dm is the ZERO_SIZE_PTR so this would oops.

   328          dm[0].dm_startbit = ADFS_DR_SIZE_BITS;
   329          dm[i].dm_endbit   = (le32_to_cpu(dr->disc_size_high) << (32 - dr->log2bpmb)) +
   330                              (le32_to_cpu(dr->disc_size) >> dr->log2bpmb) +
   331                              (ADFS_DR_SIZE_BITS - i * zone_size);

regards,
dan carpenter
