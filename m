Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab2BMWmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:42:03 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:38785 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2BMWmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:42:01 -0500
Subject: Re: [PATCH 06/13] firewire-sbp-target: Add sbp_fabric.{c,h}
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        stefanr@s5r6.in-berlin.de
In-Reply-To: <337FFBD7-6B4A-41CA-BB57-6038C935B5BF@bootc.net>
References: <4E4BD560.4010806@bootc.net>
	 <1328989452-20921-1-git-send-email-bootc@bootc.net>
	 <1328989452-20921-7-git-send-email-bootc@bootc.net>
	 <1329138360.9333.399.camel@haakon2.linux-iscsi.org>
	 <337FFBD7-6B4A-41CA-BB57-6038C935B5BF@bootc.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Feb 2012 14:41:53 -0800
Message-ID: <1329172913.4431.27.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 14:01 +0000, Chris Boot wrote:
> On 13 Feb 2012, at 13:06, Nicholas A. Bellinger wrote:
> 
> > On Sat, 2012-02-11 at 19:44 +0000, Chris Boot wrote:
> >> This serves as further glue between the target framework and SBP-2, in
> >> this case dealing with SCSI command submission and data in/out.
> >> 
> >> Signed-off-by: Chris Boot <bootc@bootc.net>
> >> Cc: Andy Grover <agrover@redhat.com>
> >> Cc: Clemens Ladisch <clemens@ladisch.de>
> >> Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
> >> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> >> ---
> >> drivers/target/sbp/sbp_fabric.c |  321 +++++++++++++++++++++++++++++++++++++++
> >> drivers/target/sbp/sbp_fabric.h |   32 ++++
> >> 2 files changed, 353 insertions(+), 0 deletions(-)
> >> create mode 100644 drivers/target/sbp/sbp_fabric.c
> >> create mode 100644 drivers/target/sbp/sbp_fabric.h
> >> 
> >> diff --git a/drivers/target/sbp/sbp_fabric.c b/drivers/target/sbp/sbp_fabric.c
> >> new file mode 100644
> >> index 0000000..edc6fda
> >> --- /dev/null
> >> +++ b/drivers/target/sbp/sbp_fabric.c
> 
> <snip>
> 
> >> +int sbp_new_cmd(struct se_cmd *se_cmd)
> >> +{
> >> +	struct sbp_target_request *req = container_of(se_cmd,
> >> +			struct sbp_target_request, se_cmd);
> >> +	int ret;
> >> +
> >> +	ret = transport_generic_allocate_tasks(se_cmd, req->cmd_buf);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	return transport_generic_map_mem_to_cmd(se_cmd, NULL, 0, NULL, 0);
> >> +}
> >> +
> > 
> > Because sbp_scsi_cmnd.c:sbp_handle_command() is using the new
> > target_submit_cmd() logic, target-core will not be calling
> > TFO->new_cmd_map() -> sbp_new_cmd() for setup here.
> > 
> > Go ahead and drop this now.
> 
> So I can just set TFO->new_cmd_map to NULL?
> 

Just drop the sbp_ops->new_cmd_map assignment, no need to explictly set
it to NULL..

> >> +
> >> +u32 sbp_get_task_tag(struct se_cmd *se_cmd)
> >> +{
> >> +	struct sbp_target_request *req = container_of(se_cmd,
> >> +			struct sbp_target_request, se_cmd);
> >> +
> >> +	/* only used for printk and family? */
> >> +	return (u32)req->orb_pointer;
> >> +}
> >> +
> > 
> > So an the ABORT_TASK TMR patches use TFO->get_task_tag() to locate a
> > referenced tag to locate the se_cmd descriptor.  Since we don't
> > support TMRs yet in sbp, this value will only be used for
> informational
> > purposes.
> 
> I'd like to support ABORT_TASK and friends at some point. The problem
> I see here though is that tags in SBP-2/3 are 48-bits wide (the ORB
> address in the initiator node's memory), and the target framework
> seems to use a u32 for this. SAM-3 Section 4.11 seems to say "A task
> tag is a value that is composed of up to 64 bits" so it might be worth
> getting that changed in the target framework?

Bumping TFO->get_task_tag and se_tmr_req->ref_task_tag to u64 is easy
enough, but it would make sense to figure out if this is really required
in practice first..

--nab

