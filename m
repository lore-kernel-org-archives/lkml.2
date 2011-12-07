Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab1LGRyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:54:44 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51140 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756720Ab1LGRyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:54:43 -0500
X-Sasl-enc: 73TDy/WvqPQsiYJyt0ZzHLwpZPFPi6j8Uz8NSfIrGdVN 1323280481
Subject: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: morgan@kernel.org, serue@us.ibm.com, dhowells@redhat.com, kzak@redhat.com
Date: Wed, 07 Dec 2011 12:54:21 -0500
Content-Type: multipart/mixed; boundary="=-/JWwNDQAnnH9dpciVBv1"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1323280461.10724.13.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/JWwNDQAnnH9dpciVBv1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

(TL;DR version: Please audit the attached setuid program)

I've recently been doing some work in software compilation, and it'd be
really handy if I could call chroot(2) as a non-root user.  The reason
to chroot is to help avoid "host contamination" - I can set up a build
root and then chroot in.  The reason to do it as non-root is, well,
requiring root to build software sucks for multiple obvious reasons.

(Now you can do LD_PRELOAD hacks to talk to a daemon like
https://github.com/wrpseudo/pseudo does, but really - too gross and too
slow).

The historical reason one can't call chroot(2) as non-root is because of
setuid binaries (hard link a setuid binary into chroot of your choice
with trojaned libc.so).  But it turns out a while back this commit:

commit 3898b1b4ebff8dcfbcf1807e0661585e06c9a91c
Author: Andrew G. Morgan <morgan@kernel.org>
Date:   Mon Apr 28 02:13:40 2008 -0700

    capabilities: implement per-process securebits

Added *exactly* what we need.  We just call:

prctl (PR_SET_SECUREBITS, SECBIT_NOROOT | SECBIT_NOROOT_LOCKED);

A setuid program to call both this and chroot(2) is *almost* good enough
for my use case - but it's a little hard to run most build software
without say /dev/null, /dev/urandom and /proc.

The other key thing Linux recently gained is CLONE_NEWNS - with this
(and also SECBIT_NOROOT), we can allow users to make bind mounts to
their heart's content, which frankly is just cool.  Bind mounts are a
really neat VFS feature.

While I was making a setuid program, I also exposed the other useful
clone flags like CLONE_NEWNET and CLONE_NEWIPC.

So...I'd like to eventually get something like this into
util-linux...possibly as a hardlink to mount (which is already setuid).

Auditing appreciated!  Am I missing anything?  Has anyone else noticed
the nice pairing of SECBIT_NOROOT and chroot(2) and used it for a tool?



--=-/JWwNDQAnnH9dpciVBv1
Content-Disposition: attachment; filename="ostbuild-user-chroot.c"
Content-Type: text/x-csrc; name="ostbuild-user-chroot.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/* -*- mode: c; tab-width: 2; indent-tabs-mode: nil -*-
 *
 * user-chroot: A setuid program that allows non-root users to safely chroot(2)
 *
 * "safely": I believe that this program, when deployed as setuid on a
 * typical "distribution" such as RHEL or Debian, does not, even when
 * used in combination with typical software installed on that
 * distribution, allow privilege escalation.
 *
 * Copyright 2011 Colin Walters <walters@verbum.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it would be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *
 */

#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdarg.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/prctl.h>
#include <sys/mount.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <linux/securebits.h>
#include <sched.h>

static void fatal (const char *message, ...) __attribute__ ((noreturn)) __attribute__ ((format (printf, 1, 2)));
static void fatal_errno (const char *message) __attribute__ ((noreturn));

static void
fatal (const char *fmt,
       ...)
{
  va_list args;
  
  va_start (args, fmt);

  vfprintf (stderr, fmt, args);
  putc ('\n', stderr);
  
  va_end (args);
  exit (1);
}

static void
fatal_errno (const char *message)
{
  perror (message);
  exit (1);
}

typedef enum {
  MOUNT_SPEC_BIND,
  MOUNT_SPEC_READONLY,
  MOUNT_SPEC_PROCFS
} MountSpecType;

typedef struct _MountSpec MountSpec;
struct _MountSpec {
  MountSpecType type;

  const char *source;
  const char *dest;
  
  MountSpec *next;
};

static MountSpec *
reverse_mount_list (MountSpec *mount)
{
  MountSpec *prev = NULL;

  while (mount)
    {
      MountSpec *next = mount->next;
      mount->next = prev;
      prev = mount;
      mount = next;
    }

  return prev;
}

int
main (int      argc,
      char   **argv)
{
  const char *argv0;
  const char *chroot_dir;
  const char *program;
  uid_t ruid, euid, suid;
  gid_t rgid, egid, sgid;
  int after_mount_arg_index;
  unsigned int n_mounts = 0;
  const unsigned int max_mounts = 50; /* Totally arbitrary... */
  char **program_argv;
  MountSpec *bind_mounts = NULL;
  MountSpec *bind_mount_iter;
  int unshare_ipc = 0;
  int unshare_net = 0;
  int unshare_pid = 0;
  int clone_flags = 0;
  int child_status = 0;
  pid_t child;

  if (argc <= 0)
    return 1;

  argv0 = argv[0];
  argc--;
  argv++;

  if (argc < 1)
    fatal ("ROOTDIR argument must be specified");

  after_mount_arg_index = 0;
  while (after_mount_arg_index < argc)
    {
      const char *arg = argv[after_mount_arg_index];
      MountSpec *mount = NULL;

      if (n_mounts >= max_mounts)
        fatal ("Too many mounts (maximum of %u)", n_mounts);
      n_mounts++;

      if (strcmp (arg, "--mount-bind") == 0)
        {
          if ((argc - after_mount_arg_index) < 3)
            fatal ("--mount-bind takes two arguments");

          mount = malloc (sizeof (MountSpec));
          mount->type = MOUNT_SPEC_BIND;
          mount->source = argv[after_mount_arg_index+1];
          mount->dest = argv[after_mount_arg_index+2];
          mount->next = bind_mounts;
          
          bind_mounts = mount;
          after_mount_arg_index += 3;
        }
      else if (strcmp (arg, "--mount-readonly") == 0)
        {
          MountSpec *mount;

          if ((argc - after_mount_arg_index) < 2)
            fatal ("--mount-readonly takes one argument");

          mount = malloc (sizeof (MountSpec));
          mount->type = MOUNT_SPEC_READONLY;
          mount->source = NULL;
          mount->dest = argv[after_mount_arg_index+1];
          mount->next = bind_mounts;
          
          bind_mounts = mount;
          after_mount_arg_index += 2;
        }
      else if (strcmp (arg, "--mount-proc") == 0)
        {
          MountSpec *mount;

          if ((argc - after_mount_arg_index) < 2)
            fatal ("--mount-proc takes one argument");

          mount = malloc (sizeof (MountSpec));
          mount->type = MOUNT_SPEC_PROCFS;
          mount->source = NULL;
          mount->dest = argv[after_mount_arg_index+1];
          mount->next = bind_mounts;
          
          bind_mounts = mount;
          after_mount_arg_index += 2;
        }
      else if (strcmp (arg, "--unshare-ipc") == 0)
        {
          unshare_ipc = 1;
          after_mount_arg_index += 1;
        }
      else if (strcmp (arg, "--unshare-pid") == 0)
        {
          unshare_pid = 1;
          after_mount_arg_index += 1;
        }
      else if (strcmp (arg, "--unshare-net") == 0)
        {
          unshare_net = 1;
          after_mount_arg_index += 1;
        }
      else
        break;
    }
        
  bind_mounts = reverse_mount_list (bind_mounts);

  if ((argc - after_mount_arg_index) < 2)
    fatal ("usage: %s [--unshare-ipc] [--unshare-pid] [--unshare-net] [--mount-proc DIR] [--mount-readonly DIR] [--mount-bind SOURCE DEST] ROOTDIR PROGRAM ARGS...", argv0);
  chroot_dir = argv[after_mount_arg_index];
  program = argv[after_mount_arg_index+1];
  program_argv = argv + after_mount_arg_index + 1;

  if (getresgid (&rgid, &egid, &sgid) < 0)
    fatal_errno ("getresgid");
  if (getresuid (&ruid, &euid, &suid) < 0)
    fatal_errno ("getresuid");

  if (ruid == 0)
    fatal ("error: ruid is 0");
  if (rgid == 0)
    rgid = ruid;

  /* CLONE_NEWNS makes it so that when we create bind mounts below,
   * we're only affecting our children, not the entire system.  This
   * way it's harmless to bind mount e.g. /proc over an arbitrary
   * directory.
   */
  clone_flags = SIGCHLD | CLONE_NEWNS;
  /* CLONE_NEWIPC and CLONE_NEWUTS are avenues of communication that
   * might leak outside the container; any IPC can be done by setting
   * up a bind mount and using files or sockets there, if desired.
   */
  if (unshare_ipc)
    clone_flags |= (CLONE_NEWIPC | CLONE_NEWUTS);
  /* CLONE_NEWPID helps ensure random build or test scripts don't kill
   * processes outside of the container.
   */
  if (unshare_pid)
    clone_flags |= CLONE_NEWPID;

  /* Isolated networking */
  if (unshare_net)
    clone_flags |= CLONE_NEWNET;

  if ((child = syscall (__NR_clone, clone_flags, NULL)) < 0)
    perror ("clone");

  if (child == 0)
    {
      /* Ensure we can't execute setuid programs.  See prctl(2) and
       * capabilities(7).
       *
       * This closes the main historical reason why only uid 0 can
       * chroot(2) - because unprivileged users can create hard links to
       * setuid binaries, and possibly confuse them into looking at data
       * (or loading libraries) that they don't expect, and thus elevating
       * privileges.
       */
      if (prctl (PR_SET_SECUREBITS,
                 SECBIT_NOROOT | SECBIT_NOROOT_LOCKED) < 0)
        fatal_errno ("prctl (SECBIT_NOROOT)");

      /* This is necessary to undo the damage "sandbox" creates on Fedora
       * by making / a shared mount instead of private.  This isn't
       * totally correct because the targets for our bind mounts may still
       * be shared, but really, Fedora's sandbox is broken.
       */
      if (mount ("/", "/", "none", MS_PRIVATE | MS_REC, NULL) < 0)
        fatal_errno ("mount(/, MS_PRIVATE | MS_REC)");

      /* Now let's set up our bind mounts */
      for (bind_mount_iter = bind_mounts; bind_mount_iter; bind_mount_iter = bind_mount_iter->next)
        {
          char *dest;
          
          asprintf (&dest, "%s%s", chroot_dir, bind_mount_iter->dest);
          
          if (bind_mount_iter->type == MOUNT_SPEC_READONLY)
            {
              if (mount (dest, dest,
                         NULL, MS_BIND | MS_PRIVATE, NULL) < 0)
                fatal_errno ("mount (MS_BIND)");
              if (mount (dest, dest,
                         NULL, MS_BIND | MS_PRIVATE | MS_REMOUNT | MS_RDONLY, NULL) < 0)
                fatal_errno ("mount (MS_BIND | MS_RDONLY)");
            }
          else if (bind_mount_iter->type == MOUNT_SPEC_BIND)
            {
              if (mount (bind_mount_iter->source, dest,
                         NULL, MS_BIND | MS_PRIVATE, NULL) < 0)
                fatal_errno ("mount (MS_BIND)");
            }
          else if (bind_mount_iter->type == MOUNT_SPEC_PROCFS)
            {
              if (mount ("proc", dest,
                         "proc", MS_MGC_VAL | MS_PRIVATE, NULL) < 0)
                fatal_errno ("mount (\"proc\")");
            }
          else
            assert (0);
          free (dest);
        }
      
      /* Actually perform the chroot. */
      if (chroot (chroot_dir) < 0)
        fatal_errno ("chroot");
      if (chdir ("/") < 0)
        fatal_errno ("chdir");

      /* Switch back to the uid of our invoking process.  These calls are
       * irrevocable - see setuid(2) */
      if (setgid (rgid) < 0)
        fatal_errno ("setgid");
      if (setuid (ruid) < 0)
        fatal_errno ("setuid");

      if (execv (program, program_argv) < 0)
        fatal_errno ("execv");
    }

  /* Let's also setuid back in the parent - there's no reason to stay uid 0, and
   * it's just better to drop privileges. */
  if (setgid (rgid) < 0)
    fatal_errno ("setgid");
  if (setuid (ruid) < 0)
    fatal_errno ("setuid");

  /* Kind of lame to sit around blocked in waitpid, but oh well. */
  if (waitpid (child, &child_status, 0) < 0)
    fatal_errno ("waitpid");
  
  if (WIFEXITED (child_status))
    return WEXITSTATUS (child_status);
  else
    return 1;
}

--=-/JWwNDQAnnH9dpciVBv1--

