Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091Ab0ELNFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:05:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35084 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0ELNFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lvFBSjL6OdE6pIuZPu1ikYkirHEpxbtYJG2y2rr2Zgslz2OVVyQNsbI8LvdVJOTHxt
         CK3fQVeMjWKhmAMlN6fg+5yrj3tN3Hdd/OPPodUxR7yOdOPAFiOdpUxCoLxKgwxVmjIm
         7kMrDorDDVgG2zlvrJLvH9azV5K3WrEbYtD7o=
Subject: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: menage@google.com, balbir@linux.vnet.ibm.com, peterz@infradead.org,
       lennart@poettering.net, jsafrane@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 15:05:41 +0200
Message-ID: <1273669541.3086.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

This is a patch (against a somewhat older kernel) which proposes to set
a default value for a cpuset cgroup that is created. At this point in
time, this is just half done since I would prefer some comments, and see
if it is acceptable, and how.

First the description of the patch.

This patch basically sets up default values for the a cpuset that is
created. By default right now, cpuset.cpus_allowed and
cpuset.mems_allowed is empty. This does not allow a task to be attached
to the cpuset. This patch sets the default value of the cpus_allowed and
mems_allowed as the same as that of the parent.

TODO:
1. Set the value depending on the exclusive flags set in other cpusets.

This does not break ABI since applications which were explicitly setting
up the cpusets will still be setting them up anyway. And if someone was
checking if a cpuset was setup or not by checking the state of
cpuset.cpus_allowed, then it was broken and should be fixed.

Now the motivation.

Looking from an application programmer's point of view, when using
cgroups, he does not want to care about unrelated subsystem and would
only manipulate the subsystem which he is concerned with. But this is a
decision that is not just limited to the application programmer. It is a
decision that is very strongly dependent on the underlying system as
well. Cgroups allows multiple subsystems to be mounted together, which
then implies they have a common hierarchy.

Now to take an example, consider a system where cpu and memory are
mounted together, since the user wants to have the same hierarchy for
both cpu and memory. Since the application cares only about memory, it
manipulates all those values. But since they are mounted together, every
time it creates a cgroup for a task, that task will also be moved to the
corresponding cpu cgroup. The solution to this is (and the one we
recommend is) to mount all cgroups separately, but this is not always
going to happen, because it is quite painful to do this. If you use
libcgroup, you need to add additional parameters to your configuration
file. If you mount it manually, you have to specify multiple mount
commands.

Anyway, coming back to the original issue. Consider that the usecase
that the user has is a valid use case, and just mix in cpuset into this
case. Now, if the application creates a cgroup, for memory, but not
knowing that the user has mounted cpusets together, it is unable to
attach a task to its newly created cgroup because cpusets is not setup.
Now the programmer is forced to know about cpusets as well.

In order to handle this situation, libcgroup has an API which takes the
parameters from the parent cgroup. But that is also broken. Consider
this same example. If there is a cgroup, that has its cpu.rt_runtime_us
parameter setup in the another child, then the create from parent API
will fail since we tried to assign too much rt bandwidth to that cgroup.
So you can neither create a cgroup nor can you assign parameters from
its parents.

Now rt-cgroups handles this situation quite well. Since real-time is
obviously a special case, the default is to have no rt bandwidth for
that cgroup. Where cpusets goes wrong is to have a *no* default values.
So the question now is, do we expect to have this non uniform policy in
implementing subsystems, or do we enforce a policy to have sane defaults
for subsystems if they prevent attaching "regular" tasks by default.

Solving it in userspace is just adding another layer, and asking either
libcgroup to have a lot of code for just one subsystem, or expecting the
programmer to know about every subsystem, just in order to handle every
corner case.

Comments?

Thanks!
Dhaval

---
 kernel/cpuset.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6/kernel/cpuset.c
===================================================================
--- linux-2.6.orig/kernel/cpuset.c
+++ linux-2.6/kernel/cpuset.c
@@ -1824,6 +1824,17 @@ static void cpuset_post_clone(struct cgr
 }
 
 /*
+ * Inherit the parent's cpus/mems values. Do not inhert the
+ * exclusivity flag
+ *
+ */
+static void cpuset_inherit_parent_values(struct cpuset *child)
+{
+	cpumask_copy(child->cpus_allowed, child->parent->cpus_allowed);
+	child->mems_allowed = child->parent->mems_allowed;
+}
+
+/*
  *	cpuset_create - create a cpuset
  *	ss:	cpuset cgroup subsystem
  *	cont:	control group that the new cpuset will be part of
@@ -1860,6 +1871,8 @@ static struct cgroup_subsys_state *cpuse
 	cs->relax_domain_level = -1;
 
 	cs->parent = parent;
+	cpuset_inherit_parent_values(cs);
+
 	number_of_cpusets++;
 	return &cs->css ;
 }



