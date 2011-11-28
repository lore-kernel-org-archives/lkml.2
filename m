Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1K1Xui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:50:38 -0500
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:52075 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab1K1Xuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:50:37 -0500
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 18:50:37 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=dEmm8njTSM3GQM9f1wrJDvBo06m+xy5lHwORutjmlbBZ3K3bS7Te4wEfsSpgsr6x;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4ED41CF7.8080002@earthlink.net>
Date: Mon, 28 Nov 2011 15:44:55 -0800
From: Stan Shebs <stanshebs@earthlink.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Kernel module for global breakpoints
Content-Type: multipart/mixed;
 boundary="------------090608000301020707090802"
X-ELNK-Trace: ae6f8838ff913eba0cc1426638a40ef67e972de0d01da940df8be4b7352e0da255f66003f3b603bb350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 70.170.59.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090608000301020707090802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

A while back, CodeSourcery (now part of Mentor Graphics) did a project 
to implement "global breakpoints" for GDB.  A global breakpoint applies 
to multiple processes, both current and future.  The idea is that one 
might have an application that is an assembly of similar processes 
(perhaps running in parallel on a multicore system), or want to break on 
a shared library function when it is first called, irrespective of which 
process calls it first.  In GDB it is specified as an addition to the 
breakpoint command - "break pow process *" will catch calls to pow() for 
instance.

One way this might be made to work is to somehow make a GDB the parent 
of all other processes, then it gets a chance to monitor each process as 
it starts up.  This is unusably inefficient; we really just need the 
breakpoint trap to be inserted at process startup and then let things 
run quietly until the trap is hit, at that point requesting the GDB user 
whether to attach to the process, or let it continue.

The code I've included here is an implementation of that scheme.  It is 
a kernel module that keeps a list of processes in which breakpoints have 
been inserted, and a list of clients (GDB, LLDB, etc) to inform about 
hits.  The interface is via /dev/breakpoint, which takes commands issued 
by a suitably-modified GDB (the GDB patches are available at 
http://sourceware.org/ml/gdb-patches/2011-06/msg00163.html).  It uses 
kprobes to hook into the relevant parts of the process and 
memory-mapping subsystems.  It's not especially complicated, the module 
consisting of just the one attached source file.

The question at hand is: what to do with this thing?  Several people 
have expressed interest in the concept, but it pushes the envelope of 
what the debugger normally does, which is to control a single process 
and its children.  It's a little freaky, though not unheard-of, to have 
a debugging agent running inside the kernel; one could argue that it's 
the kind of development support hook that *should* be in the kernel.  
It's certainly of more interest for high-performance and multi-core 
embedded systems, where the developer reasonably expects to have control 
over all the processes on the target, than for desktops, where one is 
going to be firewalled against setting breakpoints in other people's 
processes.

Any and all comments appreciated! (even "this is a stupid idea" 
reactions :-) )

Stan Shebs
stan@codesourcery.com


--------------090608000301020707090802
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="breakpoint.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="breakpoint.c"

/*
 *  Kernel module implementing global (cross-process) breakpoints
 *
 *  Copyright (c) 2010 CodeSourcery
 *  Written by Stan Shebs <stan@codesourcery.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
 */

/* This module implements a form of "global breakpoints", by which is
 * meant breakpoints inserted into multiple processes on the system,
 * including ones not under the control of a debugger.  It works by
 * simply inserting trap instructions at requested locations in the
 * processes of interest, then intercepting SIGTRAPs and converting
 * them into notifications that a debugger should attach.
 *
 * To do this, the module maintains a list of breakpoints that have
 * been defined by "clients", which could be any program, but are most
 * likely debuggers.  Breakpoints have a location defined not in terms
 * of absolute address, but as a file device/inode along with an offset,
 * since a shared library routine could end up at different addresses in
 * different processes.  Breakpoints also have a specification of processes
 * and user ids to which they apply, which can range from a specific process
 * to every process on the system (and yes, the latter is very risky!).
 *
 * Clients use this module by reading and writing /dev/breakpoint,
 * sending a couple kinds of textual commands, and getting both
 * replies and asynchronous reports of stopped processes.
 *
 * Kprobes do the interception of kernel activities.  We want to catch
 * when regions are added to the memory map, so we can insert breakpoints
 * that have been requested for all future processes, and we want to catch
 * signal raisings.  We also need to hook into ptrace attach and detach,
 * so that debuggers don't get confused by seeing global breakpoint traps
 * mixed in with their own traps.
 *
 * To debug, cat /proc/drivers/breakpoint to see a full report of the
 * module's current state.  dmesg also includes various reports of
 * activity, in particular kprobe usages.
 */

#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/device.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/ctype.h>
#include <linux/sched.h>
#include <linux/mm.h>
#include <linux/highmem.h>
#include <linux/pagemap.h>
#include <linux/kallsyms.h>
#include <linux/kernel.h>
#include <asm/uaccess.h>
#include <linux/proc_fs.h>
#include <linux/kprobes.h>
#include <linux/poll.h>

#define MAX_PACKET 200

/* This structure is for a chain of buffers that include both command
   replies and asynchronous notifications.  */

struct readable
{
  struct readable *next;

  char block[MAX_PACKET];

  int length;
};

/* Clients are typically GDB instances that have asked for global
   breakpoints.  */

struct client_instance
{
  /* Pid of the client, used to identify callers into driver.  */

  pid_t pid;

  /* User id of the client, used to only control own processes.  */

  uid_t uid;

  /* Buffer for the command coming from the client.  */

  char cmdbuf[MAX_PACKET];

  struct readable *readables;
};

#define MAX_CLIENTS 32

struct client_instance clients[MAX_CLIENTS];

int num_clients;

#define MAX_PIDS 100

struct client_note {
  uid_t uid;
  unsigned int num_pids;
  int pids[MAX_PIDS];
};

#define MAX_GBPS 100

/* x86-specific */
#define BP_LENGTH 1

#define MAX_BP_LENGTH 16

struct gbp {

  /* The device and inode of the file encompassing the breakpoint's
     location.  */

  unsigned long long dev;
  unsigned long inode;

  /* The relative position of the breakpoint within the file.  */

  unsigned long offset;

  /* Required uid of processes to get this breakpoint, or 0 if any uid
     is acceptable.  */

  uid_t uid;

  /* Flags indicating special cases.  */

  int flags;

  /* Bitmask of clients interested in this breakpoint.  */

  int client_mask;

  /* Per-client details.  */

  struct client_note notes[MAX_CLIENTS];

  /* Original contents of memory overwritten by this breakpoint when
     it is installed.  */

  unsigned char shadowed[MAX_BP_LENGTH];

  int waiting_pid;
  int waiting_uid;

} gbps[MAX_GBPS];

int last_bp = 0;

char bpbuf[MAX_BP_LENGTH];

static DECLARE_WAIT_QUEUE_HEAD(read_wait_queue);

static DECLARE_WAIT_QUEUE_HEAD(attach_wait_queue);

struct semaphore mysem;

int
add_client (void)
{
  if (num_clients == MAX_CLIENTS)
    {
      printk (KERN_DEBUG "add_client: at MAX_CLIENTS, cannot add\n");
      return -1;
    }

  /* need a lock? */

  /* Record the current task as a new client.  */
  clients[num_clients].pid = current->pid;
  clients[num_clients].uid = __task_cred (current)->uid;
  clients[num_clients].readables = NULL;

  return num_clients++;
}

/* Get the client id of the current task, typically the caller of an
   I/O operation.  */

int
get_client (void)
{
  int client;

  for (client = 0; client < num_clients; ++client)
    if (clients[client].pid == current->pid)
      return client;

  return -1;
}

/* Remove the given client as a client of this breakpoint, and
 * garbage-collect the breakpoint object itself if no clients remain.
 */
void
remove_breakpoint_client (int client, int b)
{
  int i;

  gbps[b].client_mask &= ~(1 << client);

  /* prune per-client info? */

  if (gbps[b].client_mask == 0)
    {
      gbps[b].dev = 0;
      gbps[b].inode = 0;
      gbps[b].offset = 0;
      gbps[b].uid = 0;
      gbps[b].flags = 0;
      /* Recompute last_bp.  */
      for (i = 1; i < MAX_GBPS; ++i)
	if (gbps[i].inode || gbps[i].offset)
	  last_bp = i;
    }
}

/* Add the given string to the list of replies and notifications to
 * return when read.
 */

void append_string (int client, char *str)
{
  struct readable *new_one = (struct readable *) kmalloc (sizeof(struct readable), GFP_KERNEL);
  struct readable *last;

  printk (KERN_DEBUG "append_string: client %d gets \"%s\\n", client, str);

  /* should lock? client might be multi-thread */

  new_one->next = NULL;
  strcpy (new_one->block, str);
  new_one->length = strlen (str);
  last = clients[client].readables;
  while (last && last->next)
    last = last->next;
  if (last)
    last->next = new_one;
  else
    clients[client].readables = new_one;
  wake_up_interruptible (&read_wait_queue);
}

/*
 * Access another process' address space.
 * Source/target buffer must be kernel space,
 * Do not walk the page table directly, use get_user_pages
 */
int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
{
	struct mm_struct *mm;
	struct vm_area_struct *vma;
	struct page *page;
	void *old_buf = buf;

	mm = get_task_mm(tsk);
	if (!mm)
		return 0;

	down_read(&mm->mmap_sem);
	/* ignore errors, just check how much was successfully transferred */
	while (len) {
		int bytes, ret, offset;
		void *maddr;

		ret = get_user_pages(tsk, mm, addr, 1,
				write, 1, &page, &vma);
		if (ret <= 0)
			break;

		bytes = len;
		offset = addr & (PAGE_SIZE-1);
		if (bytes > PAGE_SIZE-offset)
			bytes = PAGE_SIZE-offset;

		maddr = kmap(page);
		if (write) {
			copy_to_user_page(vma, page, addr,
					  maddr + offset, buf, bytes);
			set_page_dirty_lock(page);
		} else {
			copy_from_user_page(vma, page, addr,
					    buf, maddr + offset, bytes);
		}
		kunmap(page);
		page_cache_release(page);
		len -= bytes;
		buf += bytes;
		addr += bytes;
	}
	up_read(&mm->mmap_sem);
	mmput(mm);

	return buf - old_buf;
}

/* Given a file (represented as device/inode), see if it is used in
 * in the task's memory map anywhere.
 */
int file_is_in_map (unsigned long dev1, unsigned long ino1,
		    struct task_struct *t)
{
  struct vm_area_struct *vma;
  struct file *file2;
  struct inode *inode2;

  if (!t->mm)
    return 0;

  for (vma = t->mm->mmap; vma; vma = vma->vm_next)
    {
      file2 = vma->vm_file;
      if (!file2)
	continue;

      inode2 = file2->f_path.dentry->d_inode;
      if (inode2->i_ino == ino1
	  /* && inode->i_sb->s_dev == dev1*/)
	return 1;
    }

  return 0;
}

/* Compute the (current) address of the given breakpoint within the
 * given task.
 */
unsigned long
address_in_task (struct task_struct *task, int b)
{
  unsigned long addr;
  struct vm_area_struct *vma;
  struct file *file2;
  struct inode *inode2;

  addr = gbps[b].offset;

  for (vma = task->mm->mmap; vma; vma = vma->vm_next)
    {
      file2 = vma->vm_file;
      if (!file2)
	continue;

      inode2 = file2->f_path.dentry->d_inode;
      if (inode2->i_ino == gbps[b].inode)
	{
	  printk (KERN_DEBUG "address_in_task: for %d, bp %d offset 0x%lx is in vma at 0x%lx, place at 0x%lx \n",
		  task->pid, b, addr, vma->vm_start, addr + vma->vm_start);
	  /* Found a vma backed by our file.  */
	  addr += vma->vm_start;
	  break;
	}
    }

  return addr;
}

/* Insert the given breakpoint into the given process.  */

static void
insert_breakpoint (int client, int num, int pid)
{
  char origbuf[MAX_BP_LENGTH];
  struct task_struct *task;
  unsigned long addr;

  rcu_read_lock ();

  task = pid_task (find_vpid (pid), PIDTYPE_PID);

  if (!task)
    {
      printk (KERN_DEBUG "insert_breakpoint: no task found for %d\n", pid);
      rcu_read_unlock ();
      return;
    }

  if (!task->mm)
    {
      printk (KERN_DEBUG "insert_breakpoint: no memory map for %d\n", pid);
      rcu_read_unlock ();
      return;
    }

  /* Note that we test at this lower level since we may want to insert
     later if the process is detached.  */
  if (task->ptrace & PT_PTRACED)
    {
      printk (KERN_DEBUG "insert_breakpoint: %d is already being traced\n",
	      pid);
      rcu_read_unlock ();
      return;
    }

  addr = address_in_task (task, num);

  /* (how do we know bp not already inserted?) */
  access_process_vm (task, addr, origbuf, 1, 0);

  /* Ensure that this operation is idempotent.  */
  if (origbuf[0] != bpbuf[0])
    {
      /* Save away the original byte.  */
      gbps[num].shadowed[0] = origbuf[0];

      /* Insert the trap.  */
      access_process_vm (task, addr, bpbuf, 1, 1);
    }

  rcu_read_unlock ();

  printk (KERN_DEBUG "insert_breakpoint %d at 0x%lx in %d for client %d\n",
	  num, addr, pid, client);
}

/* Record the given pid as part of the breakpoint's client's pid list,
 * and insert it in the process.
 *
 * (It would be useful to detect processes that have gone away, and
 * remove them from the pid list.)
 */
static int
add_pid_to_breakpoint (int client, int b, int pid)
{
  int p;

  if (gbps[b].notes[client].num_pids >= MAX_PIDS)
    return 0;

  /* Only need to add once.  */
  for (p = 0; p < gbps[b].notes[client].num_pids; ++p)
    if (pid == gbps[b].notes[client].pids[p])
      return 1;

  gbps[b].notes[client].pids[p] = pid;
  ++(gbps[b].notes[client].num_pids);

  insert_breakpoint (client, b, pid);

  return 1;
}

void
insert_breakpoints_all (int client, int num)
{
  int uid_spec;
  struct task_struct *task;

  uid_spec = gbps[num].notes[client].uid;

  for_each_process (task)
  {
    if (task->mm
	&& !is_global_init (task)
	&& file_is_in_map (gbps[num].dev, gbps[num].inode, task)
	&& (uid_spec == 0 || uid_spec == __task_cred(task)->uid))
      {
	printk (KERN_DEBUG "want to insert %d into %d\n", num, task->pid);

	add_pid_to_breakpoint (client, num, task->pid);
      }
  }
}

/* Remove a global breakpoint trap from the given process.  Note that
   the client may be -1.  */

void
remove_breakpoint (int client, int num, int pid)
{
  struct task_struct *task;
  unsigned long addr;

  rcu_read_lock ();

  task = pid_task (find_vpid (pid), PIDTYPE_PID);

  if (!task)
    {
      printk (KERN_DEBUG "remove_breakpoint: no task found for %d\n", pid);
      rcu_read_unlock ();
      return;
    }

  addr = address_in_task (task, num);

  access_process_vm (task, addr, gbps[num].shadowed, 1, 1);

  rcu_read_unlock ();

  printk (KERN_DEBUG "remove_breakpoint: removed %d in %d for client %d\n",
	  num, pid, client);
}

/* Parse and execute the command sent by the given client.
 *
 * b DEV INODE ADDR UID FLAGS - create a breakpoint
 *   Normal reply: B N
 * i N PID
 *   Normal reply: OK
 * d N  - delete breakpoint N 
 *   Normal reply: OK
 */
void
interpret_command (int client)
{
  char *p = clients[client].cmdbuf;
  char reply_buf[MAX_PACKET];
  unsigned long long dev = 0;
  unsigned long addr = 0, inode = 0;
  int i, num, flags = 0, pid = 0;
  uid_t uid = 0;

  switch (*p)
    {
    case 'b':
      ++p;
      while (isspace(*p))
	++p;
      dev = simple_strtoul (p, &p, 16);
      while (isspace(*p))
	++p;
      if (*p)
	{
	  inode = simple_strtoul (p, &p, 16);
	  while (isspace(*p))
	    ++p;
	  if (*p)
	    {
	      addr = simple_strtoul (p, &p, 16);
	      while (isspace(*p))
		++p;
	      if (*p)
		{
		  uid = simple_strtoul (p, &p, 16);
		  while (isspace(*p))
		    ++p;
		  if (*p)
		    {
		      flags = simple_strtoul (p, &p, 16);
		    }
		}
	    }
	}
      for (i = 1; i < MAX_GBPS; ++i)
	if (gbps[i].offset == 0)
	  {
	    num = i;
	    break;
	  }
      if (i >= MAX_GBPS)
	{
	  printk (KERN_DEBUG "no more breakpoints available\n");
	  append_string (client, "no more breakpoints available");
	  return;
	}
      if (num > last_bp)
	last_bp = num;

      printk (KERN_DEBUG "will create gbp %d at %llx/%lx/%lx, uid %d, flags 0x%x\n",
	      num, dev, inode, addr, uid, flags);

      gbps[num].dev = dev;
      gbps[num].inode = inode;
      gbps[num].offset = addr;
      gbps[num].flags = flags;
      gbps[num].client_mask = (1 << client);
      gbps[num].notes[client].uid = uid;
      gbps[num].notes[client].num_pids = 0;

      /* Tell the client of the number we assigned to the breakpoint;
	 so that it can specify what to delete later.  */
      sprintf (reply_buf, "B %x", num);
      append_string (client, reply_buf);

      if (gbps[num].flags & 0x1)
	insert_breakpoints_all (client, num);

      break;

    case 'd':
      ++p;
      while (isspace(*p))
	++p;
      num = simple_strtol (p, &p, 16);

      if (0 < num && num < MAX_GBPS)
	{
	  remove_breakpoint_client (client, num);
	  printk (KERN_DEBUG "deleted gbp %d\n", num);
	  append_string (client, "OK");
	}
      else
	/* Let the client know, but it's not a big deal.  */
	{
	  sprintf (reply_buf, "No GBP %d", num);
	  append_string (client, reply_buf);
	}

      break;

    case 'i':
      ++p;
      while (isspace(*p))
	++p;
      num = simple_strtol (p, &p, 16);
      while (isspace(*p))
	++p;
      pid = simple_strtol (p, &p, 16);
      printk (KERN_DEBUG "want to insert gbp %d into %d\n", num, pid);
      if (add_pid_to_breakpoint (client, num, pid))
	strcpy (reply_buf, "OK");
      else
	sprintf (reply_buf, "failed I %d in %d", num, pid);
      append_string (client, reply_buf);

      break;

      /* Add a reset/clear command?  */

    default:
      printk (KERN_DEBUG "command '%s' not understood\n", p);
      sprintf (reply_buf, "command '%s' not understood", p);
      append_string (client, reply_buf);
      break;

    }
}

/* Opening the device results in the caller being listed as an
   additional client.  */

int
bp_open (struct inode *inode, struct file *fp)
{
  int client;

  printk (KERN_DEBUG "bp_open called from task %d (%s)\n",
	  current->pid, current->comm);

  client = add_client ();
  if (client < 0)
    {
      printk (KERN_DEBUG "bp_open non-client, skipping\n");
      /* return an error code? */
    }

  return 0;
}

/* We read from the device to see what is happening, which can either
 * be a reply to a command, or an indication of a breakpoint hit.
 */
ssize_t
bp_read (struct file *file, char __user *buf,
	 size_t count, loff_t *ppos)
{
  int client;
  ssize_t ret;
  struct readable *first;

#if 1
  printk (KERN_DEBUG "bp_read called from task %d, count=%d\n",
	  current->pid, count);
#endif

  client = get_client ();
  if (client < 0)
    {
      printk (KERN_DEBUG "bp_read non-client, skipping\n");
      return count;
    }

#if 0
  if (down_interruptible (&mysem))
    return -ERESTARTSYS;
#endif

  while (!clients[client].readables)
    {
#if 0
      up (&mysem);
#endif

      /* If we're non-blocking, just return nothing.  */
      if (file->f_flags & O_NONBLOCK)
	return 0;

      if (wait_event_interruptible(read_wait_queue,
				   clients[client].readables))
	return -ERESTARTSYS;

#if 0
      if (down_interruptible (&mysem))
	return -ERESTARTSYS;
#endif
    }

  first = clients[client].readables;

#if 1
  printk (KERN_DEBUG "bp_read to yield \"%s\"\n", first->block);
#endif

  ret = copy_to_user (buf, first->block, first->length);

  if (!ret)
    ret = first->length;

  clients[client].readables = first->next;

  kfree (first);

#if 1
  printk (KERN_DEBUG "bp_read returns %d\n", ret);
#endif

#if 0
  up (&mysem);
#endif

  return ret;
}

/* Process a command written to the device by a client.  */

ssize_t
bp_write (struct file *file, const char __user *buf,
	 size_t count, loff_t *ppos)
{
  int client;

  printk (KERN_DEBUG "bp_write called from task %d, count=%d\n",
	  current->pid, count);

  client = get_client ();
  if (client < 0)
    {
      printk (KERN_DEBUG "bp_write non-client, skipping\n");
      return count;
    }

  copy_from_user (clients[client].cmdbuf, buf, count);

  clients[client].cmdbuf[count] = '\0';

  interpret_command (client);

  printk (KERN_DEBUG "bp_write done, got '%s'\n", clients[client].cmdbuf);

  return count;
}

unsigned int
bp_poll (struct file *file, poll_table *wait)
{
  int client;
  unsigned int mask = 0;

  printk (KERN_DEBUG "bp_poll called from task %d\n",
	  current->pid);

  client = get_client ();
  if (client < 0)
    {
      printk (KERN_DEBUG "bp_poll non-client, skipping\n");
      return mask;
    }

  poll_wait (file, &read_wait_queue, wait);

  if (clients[client].readables)
    mask |= POLLIN | POLLRDNORM;

  /* Basically always possible to write.  */
  mask |= POLLOUT | POLLWRNORM;

  return mask;
}

/* This handles the closing of the device by a client.  At the very
 * least, we remove the client's listing with breakpoints of interest,
 * but we will also remove a breakpoint entirely if it only had the
 * one client.
 */
int
bp_release (struct inode *inode, struct file *fp)
{
  int b, client, n;

  printk (KERN_DEBUG "bp_release called from task %d (%s)\n",
	  current->pid, current->comm);

  client = get_client ();
  if (client < 0)
    {
      printk (KERN_DEBUG "bp_release non-client, skipping\n");
      return 0;
    }

  clients[client].pid = 0;

  /* Clear out any breakpoints associated with this client.  */
  for (b = 1; b <= last_bp; ++b)
    {
      /* Remove from any enumerated process that had a trap inserted.  */
      for (n = 0; n < gbps[b].notes[client].num_pids; ++n)
	remove_breakpoint (client, b, gbps[b].notes[client].pids[n]);

      remove_breakpoint_client (client, b);
    }

  return 0;
}

/* Dump internal state of the module to /proc/driver/ .  */

static int
proc_read_bp (char *page, char **start, off_t offset, int count,
	      int *eof, void *data)

{
  char *p = page;
  int b, client, n, any;
  struct readable *bufd;

  p += sprintf (p, "Global breakpoint driver\n");

  any = 0;
  for (client = 0; client < MAX_CLIENTS; ++client)
    if (clients[client].pid)
      {
	p += sprintf (p, "Client %d: task %d, uid %d\n",
		      client, clients[client].pid, clients[client].uid);
	any = 1;
	for (bufd = clients[client].readables; bufd; bufd = bufd->next)
	  p += sprintf (p, "  '%s'\n", bufd->block);
      }
  if (!any)
    p += sprintf (p, "No clients\n");

  any = 0;
  for (b = 1; b <= last_bp; ++b)
    {
      if (gbps[b].client_mask == 0)
	continue;

      p += sprintf (p, "%d at 0x%llx / %lx / %lx, flags %d, client mask 0x%x shadowed 0x%x",
		    b, gbps[b].dev, gbps[b].inode, gbps[b].offset,
		    gbps[b].flags, gbps[b].client_mask, gbps[b].shadowed[0]);
      if (gbps[b].waiting_pid)
	p += sprintf (p, " (wants insertion into %d)", gbps[b].waiting_pid);
      p += sprintf (p, "\n");
      any = 1;

      /* Dump per-client details.  */
      for (client = 0; client < num_clients; ++client)
	{
	  if (gbps[b].client_mask & (1 << client))
	    {
	      p += sprintf (p, "  %d: only uid %d, pids",
			    client, gbps[b].notes[client].uid);
	      if (gbps[b].notes[client].num_pids)
		{
		  for (n = 0; n < gbps[b].notes[client].num_pids; ++n)
		    p += sprintf (p, " %d", gbps[b].notes[client].pids[n]);
		}
	      else
		p += sprintf (p, " none");
	      p += sprintf (p, "\n");
	    }
	}
    }
  if (!any)
    p += sprintf (p, "No global breakpoints\n");

  *eof = 1;

  return p - page;
}

static struct file_operations bp_fops =
{
   .open    =  bp_open,
   .read    =  bp_read,
   .write   =  bp_write,
   .poll    =  bp_poll,
   .release =  bp_release,
};

static struct miscdevice bp_misc_dev = {
   .minor = MISC_DYNAMIC_MINOR,
   .name = "breakpoint",
   .fops = &bp_fops,
};

/* This module uses several kprobes to hook into the kernel's internal
 * processing without needing to build custom kernels.  Note that this
 * part is especially sensitive to kernel versions, and since the
 * extraction of arguments is done directly from the set of registers,
 * there is no way to detect signature changes at module compile time.
 */

struct kprobe kp_mmap_region;

int mmap_region_pre_handler (struct kprobe *kp, struct pt_regs *regs)
{
  if (strcmp (current->comm, "spinner") == 0)
    printk (KERN_DEBUG "mmap_region pre_handler called, task %d (%s) ptraced=%d mm=%lx\n",
	    current->pid, current->comm, current->ptrace & PT_PTRACED,
	    (unsigned long) current->mm);
  
  return 0;
}

void mmap_region_post_handler (struct kprobe *kp, struct pt_regs *regs,
			       unsigned long flags)
{
  int b /*, ret */;
  struct vm_area_struct *vma;
  struct file *file;
  struct inode *inode;
  unsigned long long dev;
  unsigned long ino;

  ino = 0;
  file = (struct file *) (regs->ax);  /* x86-specific */
  if (file)
    {
      inode = file->f_path.dentry->d_inode;
      ino = inode->i_ino;
    }

  if (strcmp (current->comm, "spinner") == 0)
    printk (KERN_DEBUG "mmap_region post_handler called, task %d (%s) mm=%lx file ino=%lx\n",
	    current->pid, current->comm, (unsigned long) current->mm, ino);

  if (!current->mm)
    return;

  /* Hands off any process already under ptrace control.  */
  if (current->ptrace & PT_PTRACED)
    return;

#if 0 /* use to dump all current regions */
  for (vma = current->mm->mmap; vma; vma = vma->vm_next)
    {
      file = vma->vm_file;
      dev = ino = 0;
      if (file)
	{
	  inode = file->f_path.dentry->d_inode;
	  dev = inode->i_sb->s_dev;
	  ino = inode->i_ino;
	}
      printk (KERN_DEBUG "mmap_region post_handler vma %lx file %lx ino %ld\n",
	      (unsigned long) vma, ((unsigned long) file), ino);
    }
#endif

  for (b = 1; b <= last_bp; ++b)
    {
      if (!(gbps[b].flags & 0x2))
	continue;

      for (vma = current->mm->mmap; vma; vma = vma->vm_next)
	{
	  file = vma->vm_file;
	  dev = ino = 0;
	  if (file)
	    {
	      inode = file->f_path.dentry->d_inode;
	      dev = inode->i_sb->s_dev;
	      ino = inode->i_ino;
	    }
	  if (gbps[b].inode == ino
	      /* && gbps[b].dev == dev */ )
	    {
	      printk (KERN_DEBUG "mmap_region task %d (%s) vma %lx matches bp %d dev/inode %llx/%lx\n",
		      current->pid, current->comm, (unsigned long) vma, b, dev, ino);

	      gbps[b].waiting_pid = current->pid;
	      gbps[b].waiting_uid = __task_cred(current)->uid;
	      /* We know we want to insert in this pid, done for now.  */
	      break;
	    }
	}
    }

}

/* This kprobe actually installs the global breakpoints that were noticed
 * by mmap_region calls.
 *
 * do_execve is not ideal, because it doesn't catch all callers down to
 * mmap_region.
 */

struct kprobe kp_do_execve;

int do_execve_pre_handler (struct kprobe *kp, struct pt_regs *regs)
{
  if (strcmp (current->comm, "dmesg") != 0)
    printk (KERN_DEBUG "do_execve pre_handler called, task %d (%s), ptraced=%d\n",
	    current->pid, current->comm, current->ptrace & PT_PTRACED);
  
  return 0;
}

void do_execve_post_handler (struct kprobe *kp, struct pt_regs *regs,
			     unsigned long flags)
{
  if (strcmp (current->comm, "dmesg") != 0)
    printk (KERN_DEBUG "do_execve post_handler called, task %d (%s), ptraced=%d\n",
	    current->pid, current->comm, current->ptrace & PT_PTRACED);

  {int b, client, uid_spec, ret;
  for (b = 1; b <= last_bp; ++b)
    {
      if (gbps[b].waiting_pid)
	{
	  for (client = 0; client < num_clients; ++client)
	    {
	      uid_spec = gbps[b].notes[client].uid;

	      if (gbps[b].client_mask & (1 << client)
		  && (uid_spec == 0 || uid_spec == gbps[b].waiting_uid))
		{
		  ret = add_pid_to_breakpoint (client, b, gbps[b].waiting_pid);
		  /* Warn about failure, but not much else we can do
		     at this point.  */
		  if (ret == 0)
		    printk (KERN_DEBUG "do_execve post_handler, task %d (%s), failed to add pid to breakpoint %d\n",
			    current->pid, current->comm, b);
		}
	    }
	  gbps[b].waiting_pid = 0;
	  gbps[b].waiting_uid = 0;
	}
    }
  }
}

/* Kprobe that intercepts the SIGTRAP signal.  */

struct kprobe kp_force_sig_info;

/* Given a trap in a task at some address, search the global
 * breakpoints for a hit, and return a breakpoint number if
 * found, or -1.
 */
int
find_bp_hit (struct task_struct *t, unsigned long addr)
{
  int b;
  struct vm_area_struct *vma;
  struct file *file2;
  struct inode *inode2;
  int ino = 0;

  vma = find_vma_intersection (t->mm, addr, addr + BP_LENGTH);

  if (!vma)
    return -1;

  file2 = vma->vm_file;
  if (file2)
    {
      inode2 = file2->f_path.dentry->d_inode;
      ino = inode2->i_ino;
    }

  for (b = 1; b <= last_bp; ++b)
    {
      if (ino == gbps[b].inode
	  && (addr == gbps[b].offset + vma->vm_start))
	return b;
    }

  return -1;
}

int
force_sig_info_pre_handler (struct kprobe *kp, struct pt_regs *regs)
{
  int sig, b, client;
  struct task_struct *t = current;
  struct pt_regs *t_regs;
  unsigned long t_pc, addr;
  char notice_buf[MAX_PACKET];

  sig = (int) (regs->ax);  /* x86-specific */

  t_regs = task_pt_regs (t);
  t_pc = instruction_pointer (t_regs);

  printk (KERN_DEBUG "force_sig_info pre_handler called, sig=%d, pid=%d, pc=%lx\n",
	  sig, t->pid, t_pc);

  if (sig != SIGTRAP)
    {
      printk (KERN_DEBUG "force_sig_info pre_handler: not a SIGTRAP\n");
      return 0;
    }

  /* Keep hands off any process already under ptrace control.  */
  if (t->ptrace & PT_PTRACED)
    {
      printk (KERN_DEBUG "force_sig_info pre_handler: already being ptraced\n");
      return 0;
    }

  /* Adjust the address to the actual position of the trap.  */
  addr = t_pc - 1;  /* x86-specific */

  b = find_bp_hit (t, addr);

  /* If no global breakpoint, then it was probably a trap compiled
     into the program.  */
  if (b <= 0)
    {
      printk (KERN_DEBUG "force_sig_info pre_handler: no breakpoint at this address\n");
      return 0;
    }

  printk (KERN_DEBUG "force_sig_info pre_handler: hit bp %d, want to suspend %d for attach\n",
	  b, t->pid);

  /* Adjust saved PC.  */
  t_regs->ip = addr;  /* x86-specific */

  /* Notify each interested client of this event.  Most likely only
     one will ever successfully attach, but we have no way of
     predicting who will want it first (perhaps one of the GDBs has
     been ^Z-suspended, and won't even check for another hour).  */

  for (client = 0; client < num_clients; ++client)
    {
      if (gbps[b].client_mask & (1 << client))
	{
	  sprintf (notice_buf, "%% %x %x %lx", t->pid, b, addr);
	  append_string (client, notice_buf);
	}
    }

  /* Hang here.  */
  {
    struct k_sigaction *action;

    action = &t->sighand->action[sig - 1];
    printk (KERN_DEBUG "force_sig_info pre_handler: action is %lx, handler is %lx\n",
	    (unsigned long) action, ((unsigned long) (action->sa.sa_handler)));

    /* (should copy old one to restore later) */
    regs->ax = SIGSTOP;  /* x86-specific */
    action->sa.sa_handler = SIG_DFL;

    printk (KERN_DEBUG "force_sig_info pre_handler: action is now %lx, handler is %lx\n",
	    (unsigned long) action, ((unsigned long) (action->sa.sa_handler)));
  }

  return 0;
}

struct kprobe kp_ptrace_attach;

int ptrace_attach_pre_handler (struct kprobe *kp, struct pt_regs *regs)
{
  printk (KERN_DEBUG "ptrace_attach pre_handler called, task %d (%s)\n",
	  current->pid, current->comm);
  
  return 0;
}

void ptrace_attach_post_handler (struct kprobe *kp, struct pt_regs *regs,
				 unsigned long flags)
{
  struct task_struct *t;
  int c, client = -1, b, n;

  printk (KERN_DEBUG "ptrace_attach post_handler called, task %d (%s)\n",
	  current->pid, current->comm);

  t = (struct task_struct *) (regs->ax);  /* x86-specific */

  printk (KERN_DEBUG "ptrace_attach post_handler called, task %d (%s) attach %lx task %d (%s)\n",
	  current->pid, current->comm,
	  (unsigned long) (t), t->pid, t->comm);

  for (c = 0; c < num_clients; ++c)
    if (current->pid == clients[c].pid)
      {
	client = c;
	break;
      }

#if 1
  /* This snippet is a hack to be used only for debugging trap
     placement - if a non-client is doing the attaching, leave the
     global breakpoints in so we can look at them.  */
  if (client < 0)
    return;
#endif

  /* Clean out global breakpoint traps so that GDB will have a clear
     field for inserting its own traps.  Note that we do this whether
     or not the attaching program is a client; programs already being
     debugged should never have global breakpoints installed in
     them.  */
  for (b = 1; b <= last_bp; ++b)
    {
      for (n = 0; n < gbps[b].notes[client].num_pids; ++n)
	if (t->pid == gbps[b].notes[client].pids[n])
	  {
	    remove_breakpoint (client, b, t->pid);
	    /* Notify the client of each removal, so it can replace
	       with its own traps.  Note it is difficult or impossible
	       for a client to guess which of the wildcarded
	       breakpoints we ended up installing, so just send them
	       all.  */
	    if (client >= 0)
	      {
		char reply_buf[MAX_PACKET];
		sprintf (reply_buf, "# %x %x", t->pid, b);
		append_string (client, reply_buf);
	      }
	  }
    }


  /* (should restore the original SIGSTOP handler here) */
}

/* Use a kprobe on ptrace_detach to reinstall global breakpoints that
   had been removed during the attach.  */

struct kprobe kp_ptrace_detach;

int ptrace_detach_pre_handler (struct kprobe *kp, struct pt_regs *regs)
{
  int b, client;
  struct task_struct *t;

  /* x86-specific acquisition of the task being detached.  */
  t = (struct task_struct *) (regs->ax);

  printk (KERN_DEBUG "ptrace_detach pre_handler called, task %d (%s) detach 0x%lx task %d (%s)\n",
	  current->pid, current->comm,
	  (unsigned long) (t), t->pid, t->comm);

  /* Reinstall all the global breakpoint traps.  */
  for (b = 1; b <= last_bp; ++b)
    {
      for (client = 0; client < num_clients; ++client)
	{
	  if (gbps[b].client_mask & (1 << client))
	    {
	      int p;

	      /* Only re-add breakpoints that have this process in their
		 pid list.  */
	      for (p = 0; p < gbps[b].notes[client].num_pids; ++p)
		if (t->pid == gbps[b].notes[client].pids[p])
		  {
		    insert_breakpoint (client, b, t->pid);
		    break;
		  }
	    }
	}
    }

  return 0;
}

static int
bp_init (void)
{
  int err;
  unsigned long kaddr;

  printk (KERN_DEBUG "bp_init called\n");

  /* What to use for trapping - x86-specific */
  bpbuf[0] = 0xcc;

  err = misc_register (&bp_misc_dev);

  create_proc_read_entry ("driver/breakpoint", 0444, NULL, proc_read_bp, NULL);

  /* Set up the kprobes we will need.  */

  kaddr = kallsyms_lookup_name ("mmap_region");
  if (kaddr)
    printk (KERN_DEBUG "mmap_region at %lx", kaddr);
  else
    printk (KERN_DEBUG "mmap_region not found");

  kp_mmap_region.pre_handler = mmap_region_pre_handler;
  kp_mmap_region.post_handler = mmap_region_post_handler;
  kp_mmap_region.addr = (kprobe_opcode_t *) kaddr;

  register_kprobe (&kp_mmap_region);

  kaddr = kallsyms_lookup_name ("do_execve");
  if (kaddr)
    printk (KERN_DEBUG "do_execve at %lx", kaddr);
  else
    printk (KERN_DEBUG "do_execve not found");

  kp_do_execve.pre_handler = do_execve_pre_handler;
  kp_do_execve.post_handler = do_execve_post_handler;
  kp_do_execve.addr = (kprobe_opcode_t *) kaddr;

  register_kprobe (&kp_do_execve);

  kaddr = kallsyms_lookup_name ("force_sig_info");
  if (kaddr)
    printk (KERN_DEBUG "force_sig_info at %lx", kaddr);
  else
    printk (KERN_DEBUG "force_sig_info not found");

  kp_force_sig_info.pre_handler = force_sig_info_pre_handler;
  kp_force_sig_info.addr = (kprobe_opcode_t *) kaddr;

  register_kprobe (&kp_force_sig_info);

  kaddr = kallsyms_lookup_name ("ptrace_attach");
  if (kaddr)
    printk (KERN_DEBUG "ptrace_attach at %lx", kaddr);
  else
    printk (KERN_DEBUG "ptrace_attach not found");

  kp_ptrace_attach.pre_handler = ptrace_attach_pre_handler;
  kp_ptrace_attach.post_handler = ptrace_attach_post_handler;
  kp_ptrace_attach.addr = (kprobe_opcode_t *) kaddr;

  register_kprobe (&kp_ptrace_attach);

  kaddr = kallsyms_lookup_name ("ptrace_detach");
  if (kaddr)
    printk (KERN_DEBUG "ptrace_detach at %lx", kaddr);
  else
    printk (KERN_DEBUG "ptrace_detach not found");

  kp_ptrace_detach.pre_handler = ptrace_detach_pre_handler;
  kp_ptrace_detach.addr = (kprobe_opcode_t *) kaddr;

  register_kprobe (&kp_ptrace_detach);

  return 0;
}

static void
bp_exit (void)
{
  printk (KERN_DEBUG "bp_exit called\n");

  /* (should attempt to clean up any inserted traps?) */

  unregister_kprobe (&kp_ptrace_detach);
  unregister_kprobe (&kp_ptrace_attach);
  unregister_kprobe (&kp_force_sig_info);
  unregister_kprobe (&kp_do_execve);
  unregister_kprobe (&kp_mmap_region);

  remove_proc_entry ("driver/breakpoint", NULL);

  misc_deregister (&bp_misc_dev);
}

module_init (bp_init);
module_exit (bp_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("CodeSourcery");
MODULE_DESCRIPTION("Breakpoint agent");

--------------090608000301020707090802--
