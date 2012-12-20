Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab2LTV37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:29:59 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54546 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2LTV3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:29:49 -0500
Date: Thu, 20 Dec 2012 13:29:49 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.8
Message-ID: <alpine.DEB.2.00.1212201319500.16508@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates for 3.8 from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There's a trivial conflict in net/ceph/osd_client.c dealing with rbtree 
node initialization; the resolution is to keep the RB_CLEAR_NODE() call 
(see 4c199a93 for the conflicting commit).

There are a few different groups of commits here.  The largest is Alex's 
ongoing work to enable the coming RBD features (cloning, striping).  
There is some cleanup in libceph that goes along with it.  Cyril and David 
have fixed some problems with NFS reexport (leaking dentries and page 
locks), and there is a batch of patches from Yan fixing problems with the 
fs client when running against a clustered MDS.  There are a few bug fixes 
mixed in for good measure, many of which will be going to the stable trees 
once they're upstream.

My apologies for the late pull.  There is still a gremlin in the rbd 
map/unmap code and I was hoping to include the fix for that as well, but 
we haven't been able to confirm the fix is correct yet; I'll send that in 
a separate pull once it's nailed down.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (53):
      rbd: let con_work() handle backoff
      rbd: define common queue_con_delay()
      rbd: define rbd_update_mapping_size()
      rbd: define rbd_dev_v2_refresh()
      rbd: implement feature checks
      rbd: activate v2 image support
      rbd: fix bug in rbd_dev_id_put()
      rbd: zero return code in rbd_dev_image_id()
      rbd: fix read-only option name
      rbd: kill rbd_req_{read,write}()
      rbd: drop rbd_do_op() opcode and flags
      rbd: consolidate rbd_do_op() calls
      rbd: verify rbd image order value
      rbd: increase maximum snapshot name length
      rbd: simplify rbd_merge_bvec()
      rbd: kill rbd_device->rbd_opts
      rbd: simplify rbd_rq_fn()
      rbd: remove snapshots on error in rbd_add()
      rbd: make pool_id a 64 bit value
      rbd: move snap info out of rbd_mapping struct
      rbd: rename snap_exists field
      rbd: move ceph_parse_options() call up
      rbd: do all argument parsing in one place
      rbd: get rid of snap_name_len
      rbd: remove options args from rbd_add_parse_args()
      rbd: remove snap_name arg from rbd_add_parse_args()
      rbd: pass and populate rbd_options structure
      rbd: have rbd_add_parse_args() return error
      rbd: define image specification structure
      rbd: add reference counting to rbd_spec
      rbd: fill rbd_spec in rbd_add_parse_args()
      rbd: don't pass rbd_dev to rbd_get_client()
      rbd: consolidate rbd_dev init in rbd_add()
      rbd: define rbd_dev_{create,destroy}() helpers
      rbd: encapsulate last part of probe
      rbd: allow null image name
      rbd: allow null image name
      rbd: get parent spec for version 2 images
      libceph: define ceph_pg_pool_name_by_id()
      rbd: get additional info in parent spec
      rbd: do not allow remove of mounted-on image
      ceph: don't reference req after put
      libceph: avoid using freed osd in __kick_osd_requests()
      rbd: get rid of RBD_MAX_SEG_NAME_LEN
      rbd: remove linger unconditionally
      rbd: don't use ENOTSUPP
      libceph: socket can close in any connection state
      libceph: report connection fault with warning
      libceph: init osd->o_node in create_osd()
      libceph: init event->node in ceph_osdc_create_event()
      libceph: don't use rb_init_node() in ceph_osdc_alloc_request()
      libceph: register request before unregister linger
      rbd: get rid of rbd_{get,put}_dev()

Cyril Roelandt (1):
      ceph: fix dentry reference leak in ceph_encode_fh().

David Zafman (3):
      ceph: fix dentry reference leak in encode_fh()
      ceph: Fix NULL ptr crash in strlen()
      libceph: Unlock unprocessed pages in start_read() error path

Joe Perches (1):
      bdi_register: add __printf verification, fix arg mismatch

Sage Weil (4):
      libceph: avoid NULL kref_put from NULL alloc_msg return
      libceph: fix osdmap decode error paths
      ceph: Fix i_size update race
      libceph: remove 'osdtimeout' option

Yan, Zheng (6):
      ceph: Hold caps_list_lock when adjusting caps_{use, total}_count
      ceph: Don't update i_max_size when handling non-auth cap
      ceph: Fix infinite loop in __wake_requests
      ceph: Don't add dirty inode to dirty list if caps is in migration
      ceph: Fix __ceph_do_pending_vmtruncate
      ceph: call handle_cap_grant() for cap import message

 Documentation/ABI/testing/sysfs-bus-rbd |    4 +
 drivers/block/rbd.c                     | 1389 +++++++++++++++++++++----------
 drivers/block/rbd_types.h               |    2 -
 fs/ceph/addr.c                          |   60 ++-
 fs/ceph/caps.c                          |   18 +-
 fs/ceph/export.c                        |    6 +-
 fs/ceph/file.c                          |   73 +-
 fs/ceph/inode.c                         |   15 +-
 fs/ceph/mds_client.c                    |   11 +-
 fs/ceph/super.c                         |    4 +-
 include/linux/backing-dev.h             |    1 +
 include/linux/ceph/libceph.h            |    2 -
 include/linux/ceph/osdmap.h             |    1 +
 include/linux/ceph/rados.h              |    2 +
 net/ceph/ceph_common.c                  |    3 +-
 net/ceph/messenger.c                    |  110 ++--
 net/ceph/osd_client.c                   |   60 +--
 net/ceph/osdmap.c                       |   47 +-
 18 files changed, 1199 insertions(+), 609 deletions(-)
